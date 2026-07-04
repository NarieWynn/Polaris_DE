#include "wifi.h"
#include <QDBusReply>
#include <QProcess>

WifiManager::WifiManager(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &WifiManager::updateWifi);
    m_timer->start(5000);  // update mỗi 5 giây
    updateWifi();
}

void WifiManager::updateWifi() {
    QProcess proc;
    proc.start("nmcli", {"-t", "-f", "active,ssid,signal", "dev", "wifi"});
    proc.waitForFinished();

    QString output = proc.readAllStandardOutput();
    bool found = false;

    for (const QString &line : output.split('\n')) {
        if (line.startsWith("yes:")) {
            QStringList parts = line.split(':');
            if (parts.size() >= 3) {
                m_isConnected = true;
                m_ssid = parts[1];
                m_signalStrength = parts[2].toInt();
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
}

QString WifiManager::ssid() const { return m_ssid; }
int WifiManager::signalStrength() const { return m_signalStrength; }
bool WifiManager::isConnected() const { return m_isConnected; }