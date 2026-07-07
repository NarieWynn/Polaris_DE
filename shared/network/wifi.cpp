#include "wifi.h"
#include <QProcess>
#include <QDebug>
#include <algorithm>
#include <QCoreApplication>
#include <QDir>
WifiManager::WifiManager(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &WifiManager::updateWifi);
    m_timer->start(5000);

    m_proc = new QProcess(this);
    m_scanProc = new QProcess(this);
    m_connProc = new QProcess(this);
    m_disProc = new QProcess(this);

    // Monitor current Wi-Fi connection status
    connect(m_proc, &QProcess::finished, this, [this](int exitCode) {
        if (exitCode != 0) return;
        QString output = m_proc->readAllStandardOutput();
        bool found = false;

        for (const QString &line : output.split('\n')) {
            if (line.startsWith("yes:")) {
                qsizetype lastColon = line.lastIndexOf(':');
                qsizetype firstColon = line.indexOf(':');
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
        scan();
    });

    // Handle asynchronous network scanning and update the model only on data change
    connect(m_scanProc, &QProcess::finished, this, [this](int exitCode) {
        if (exitCode != 0) {
            m_isScanning = false;
            emit scanningChanged();
            return;
        }
        QString output = m_scanProc->readAllStandardOutput();
        QMap<QString, QVariantMap> bestNetwork;

        for (const QString &line : output.split('\n')) {
            if (line.trimmed().isEmpty()) continue;
            qsizetype lastColon = line.lastIndexOf(':');
            qsizetype secondLastColon = line.lastIndexOf(':', lastColon - 1);
            qsizetype thirdLastColon = line.lastIndexOf(':', secondLastColon - 1);
            if (thirdLastColon < 0) continue;

            QString ssid = line.left(thirdLastColon);
            int signal = line.mid(thirdLastColon + 1, secondLastColon - thirdLastColon - 1).toInt();
            bool isActive = (line.mid(secondLastColon + 1, lastColon - secondLastColon - 1).trimmed() == "yes");
            QString security = line.mid(lastColon + 1).trimmed();

            if (ssid.isEmpty()) continue;
            bool isProtected = (!security.isEmpty() && security != "--" && security != "open");

            if (!bestNetwork.contains(ssid) || isActive) {
                QVariantMap network;
                network["ssid"] = ssid;
                network["signal"] = signal;
                network["isConnected"] = isActive;
                network["isProtected"] = isProtected;
                bestNetwork[ssid] = network;
            }
        }

        QVariantList connectedList, disconnectedList;
        for (const QVariantMap &network : bestNetwork) {
            if (network["isConnected"].toBool()) connectedList.append(network);
            else disconnectedList.append(network);
        }

        std::ranges::sort(disconnectedList.begin(), disconnectedList.end(), [](const QVariant &a, const QVariant &b) {
            return a.toMap()["signal"].toInt() > b.toMap()["signal"].toInt();
        });

        QVariantList newList;
        newList.append(connectedList);
        newList.append(disconnectedList);

        m_isScanning = false;
        emit scanningChanged();

        // Prevent redundant UI updates if the network list state remains unchanged
        if (m_networks != newList) {
            m_networks = newList;
            emit networksChanged();
        }
    });

    // Handle asynchronous connection process
    connect(m_connProc, &QProcess::finished, this, [this](int exitCode) {
        if (exitCode != 0) {
            QString err = m_connProc->readAllStandardError();
            qDebug() << "Connection attempt failed:" << err;
            emit connectError(err);
        } else {
            updateWifi();
            QTimer::singleShot(2000, this, [this]() { updateWifi(); });
        }
    });

    // Handle asynchronous disconnection process
    connect(m_disProc, &QProcess::finished, this, [this](int exitCode) {
        if (exitCode == 0) {
            updateWifi();
            QTimer::singleShot(1500, this, [this]() { updateWifi(); });
        }
    });

    updateWifi();
}

WifiManager::~WifiManager() {
    for (QProcess *p : {m_proc, m_scanProc, m_connProc, m_disProc}) {
        if (p && p->state() == QProcess::Running) {
            p->kill();
            p->waitForFinished(200);
        }
    }
}

void WifiManager::updateWifi() {
    if (!m_isWifiEnabled) return;
    if (m_proc->state() == QProcess::Running) {
        m_proc->kill();
        m_proc->waitForFinished(100);
    }
    m_proc->start("nmcli", {"-t", "-f", "active,ssid,signal", "dev", "wifi"});
}

void WifiManager::setWifiEnabled(bool enabled) {
    if (m_isWifiEnabled == enabled) return;
    m_isWifiEnabled = enabled;
    emit wifiEnabledChanged();

    QProcess::startDetached("nmcli", {"radio", "wifi", enabled ? "on" : "off"});

    if (!enabled) {
        m_networks.clear();
        m_ssid = "";
        m_isConnected = false;
        m_signalStrength = 0;
        emit networksChanged();
        emit wifiChanged();
    } else {
        // Poll at staggered intervals to capture device initialization and auto-connection states
        QTimer::singleShot(1500, this, [this]() { updateWifi(); });
        QTimer::singleShot(3500, this, [this]() { updateWifi(); });
        QTimer::singleShot(6000, this, [this]() { updateWifi(); });
    }
}

bool WifiManager::isWifiEnabled() const { return m_isWifiEnabled; }

void WifiManager::openPopup() {

    QString binPath = QCoreApplication::applicationDirPath();
    QDir dir(binPath);
    dir.cdUp();
    dir.cd("wifi_popup");

    QString popupPath = dir.absoluteFilePath("polaris_wifi_popup");

    qDebug() << "Launching popup from:" << popupPath;
    QProcess::startDetached(popupPath, {});
}

void WifiManager::scan() {
    if (!m_isWifiEnabled || m_isScanning) return;
    m_isScanning = true;
    emit scanningChanged();

    if (m_scanProc->state() == QProcess::Running) {
        m_scanProc->kill();
        m_scanProc->waitForFinished(100);
    }
    m_scanProc->start("nmcli", {"-t", "-f", "ssid,signal,active,security", "dev", "wifi", "list", "--rescan", "no"});
}

void WifiManager::connectTo(const QString &ssid, const QString &password) {
    if (m_connProc->state() == QProcess::Running) {
        m_connProc->kill();
        m_connProc->waitForFinished(100);
    }
    if (password.isEmpty()) {
        m_connProc->start("nmcli", {"dev", "wifi", "connect", ssid});
    } else {
        m_connProc->start("nmcli", {"dev", "wifi", "connect", ssid, "password", password});
    }
}

void WifiManager::disconnect() {
    if (m_ssid.isEmpty()) return;
    if (m_disProc->state() == QProcess::Running) {
        m_disProc->kill();
        m_disProc->waitForFinished(100);
    }
    m_disProc->start("nmcli", {"connection", "down", "id", m_ssid});
}

QVariantList WifiManager::getSavedNetworks() {
    QVariantList savedList;
    QProcess proc;
    // nmcli connection show lists all configured profiles
    proc.start("nmcli", {"-t", "-f", "NAME,TYPE", "connection", "show"});
    proc.waitForFinished();

    QString output = proc.readAllStandardOutput();
    for (const QString &line : output.split('\n')) {
        if (line.contains(":802-11-wireless")) {
            QString ssid = line.section(':', 0, 0);
            QVariantMap net;
            net["ssid"] = ssid;
            savedList.append(net);
        }
    }
    return savedList;
}

void WifiManager::forgetNetwork(const QString &ssid) {
    QProcess proc;
    proc.start("nmcli", {"connection", "delete", "id", ssid});
    proc.waitForFinished();
    emit networksChanged();
}

void WifiManager::togglePopup() { emit popupToggled(); }

QString WifiManager::ssid() const { return m_ssid; }
int WifiManager::signalStrength() const { return m_signalStrength; }
bool WifiManager::isConnected() const { return m_isConnected; }
QVariantList WifiManager::networks() const { return m_networks; }
bool WifiManager::isScanning() const { return m_isScanning; }