#include "wifi.h"
#include <QProcess>
#include <QDebug>

WifiManager::WifiManager(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &WifiManager::updateWifi);
    m_timer->start(5000);
    updateWifi();
}

void WifiManager::updateWifi() {
    // 1. Chỉ tạo m_proc duy nhất 1 lần (nếu chưa có)
    if (!m_proc) {
        m_proc = new QProcess(this);

        // 2. Chỉ kết nối tín hiệu 1 lần duy nhất lúc khởi tạo
        connect(m_proc, &QProcess::finished, this, [this](int exitCode) {
            if (exitCode != 0) return;

            QString output = m_proc->readAllStandardOutput();
            bool found = false;

            for (const QString &line : output.split('\n')) {
                if (line.startsWith("yes:")) {
                    int lastColon = line.lastIndexOf(':');
                    int firstColon = line.indexOf(':');
                    if (lastColon > firstColon) {
                        m_isConnected = true;
                        m_ssid = line.mid(firstColon + 1, lastColon - firstColon - 1);
                        m_signalStrength = line.mid(lastColon + 1).toInt();
                        found = true;
                    }
                    break;
                }
            }

            if (!found) {
                m_isConnected = false;
                m_ssid = "";
                m_signalStrength = 0;
            }
            emit wifiChanged();
        });
    }

    // 3. Mỗi lần gọi updateWifi, chỉ cần gọi start thôi (nếu đang chạy thì nó tự restart lại hoặc mày gọi m_proc->kill() trước nếu muốn)
    if (m_proc->state() == QProcess::Running) {
        m_proc->kill(); // Dừng lệnh cũ nếu nó đang chạy dở
    }
    m_proc->start("nmcli", {"-t", "-f", "active,ssid,signal", "dev", "wifi"});
}

void WifiManager::openPopup() {
    QProcess::startDetached(
        "/home/nariewynn/Projects/Polaris/cmake-build-debug/modules/wifi_popup/polaris_wifi_popup",
        {}
    );
}

void WifiManager::scan() {
    if (m_isScanning) return;
    m_isScanning = true;
    emit scanningChanged();

    if (!m_scanProc) {
        m_scanProc = new QProcess(this);
        connect(m_scanProc, &QProcess::finished, this, [this](int exitCode) {
            if (exitCode != 0) {
                m_isScanning = false;
                emit scanningChanged();
                return;
            }

            QString output = m_scanProc->readAllStandardOutput();
            m_networks.clear();

            QMap<QString, QVariantMap> bestNetwork;
            for (const QString &line : output.split('\n')) {
                if (line.trimmed().isEmpty()) continue;
                int lastColon = line.lastIndexOf(':');
                int secondLastColon = line.lastIndexOf(':', lastColon - 1);
                if (secondLastColon < 0) continue;

                QString ssid = line.left(secondLastColon);
                int signal = line.mid(secondLastColon + 1, lastColon - secondLastColon - 1).toInt();
                bool isActive = line.mid(lastColon + 1).trimmed() == "yes";

                if (ssid.isEmpty()) continue;

                if (!bestNetwork.contains(ssid) || isActive) {
                    QVariantMap network;
                    network["ssid"] = ssid;
                    network["signal"] = signal;
                    network["isConnected"] = isActive;
                    bestNetwork[ssid] = network;
                }
            }

            QVariantList connectedList;
            QVariantList disconnectedList;
            for (const QVariantMap &network : bestNetwork) {
                if (network["isConnected"].toBool()) connectedList.append(network);
                else disconnectedList.append(network);
            }

            std::ranges::sort(disconnectedList.begin(), disconnectedList.end(), [](const QVariant &a, const QVariant &b) {
                return a.toMap()["signal"].toInt() > b.toMap()["signal"].toInt();
            });

            m_networks.append(connectedList);
            m_networks.append(disconnectedList);

            m_isScanning = false;
            emit scanningChanged();
            emit networksChanged();
        });
    }

    if (m_scanProc->state() == QProcess::Running) m_scanProc->kill();
    m_scanProc->start("nmcli", {"-t", "-f", "ssid,signal,active", "dev", "wifi", "list", "--rescan", "no"});
}

void WifiManager::connectTo(const QString &ssid, const QString &password) {
    qDebug() << "connecting to:" << ssid;

    QProcess proc;
    if (password.isEmpty()) {
        proc.start("nmcli", {"dev", "wifi", "connect", ssid});
    } else {
        proc.start("nmcli", {"dev", "wifi", "connect", ssid, "password", password});
    }
    proc.waitForFinished();

    qDebug() << "exit code:" << proc.exitCode();
    qDebug() << "stdout:" << proc.readAllStandardOutput();
    qDebug() << "stderr:" << proc.readAllStandardError();

    if (proc.exitCode() != 0) {
        emit connectError(proc.readAllStandardError());
    } else {
        updateWifi();
        scan();
    }
}

void WifiManager::disconnect() {
    if (m_ssid.isEmpty()) {
        return;
    }
    QProcess proc;
    proc.start("nmcli", {"connection", "down", "id", m_ssid});
    proc.waitForFinished();
    updateWifi();
    scan();
}

void WifiManager::togglePopup() {
    emit popupToggled();
}

QString WifiManager::ssid() const { return m_ssid; }
int WifiManager::signalStrength() const { return m_signalStrength; }
bool WifiManager::isConnected() const { return m_isConnected; }
QVariantList WifiManager::networks() const { return m_networks; }
bool WifiManager::isScanning() const { return m_isScanning; }