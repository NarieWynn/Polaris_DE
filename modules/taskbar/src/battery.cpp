#include "battery.h"
#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QDebug>

BatteryManager::BatteryManager(QObject *parent) : QObject(parent) {
    m_timer = new QTimer(this);

    connect(m_timer, &QTimer::timeout, this, &BatteryManager::updateBatteryStatus);

    updateBatteryStatus();

    m_timer->start(3000);
}

void BatteryManager::updateBatteryStatus() {
    QDir dir("/sys/class/power_supply");


    QStringList filters;
    filters << "BAT*";
    dir.setNameFilters(filters);

    QStringList batteries = dir.entryList(QDir::Dirs);

    if (batteries.isEmpty()) {
        qWarning() << "There is no battery in sysfs!";
        return;
    }


    const QString &batName = batteries.first();
    QString basePath = "/sys/class/power_supply/" + batName + "/";

    int newLevel = m_batteryLevel;
    bool newCharging = m_isCharging;


    QFile fileCapacity(basePath + "capacity");
    if (fileCapacity.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&fileCapacity);
        newLevel = in.readLine().trimmed().toInt();
        fileCapacity.close();
    }


    QFile fileStatus(basePath + "status");
    if (fileStatus.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&fileStatus);
        QString status = in.readLine().trimmed();
        newCharging = (status == "Charging");
        fileStatus.close();
    }


    if (newLevel != m_batteryLevel || newCharging != m_isCharging) {
        m_batteryLevel = newLevel;
        m_isCharging = newCharging;
        emit batteryChanged();
        qDebug() << "Battery updated dynamically:" << m_batteryLevel << "%" << (m_isCharging ? "(Charging)" : "");
    }
}

int BatteryManager::batteryLevel() const {
    return m_batteryLevel;
}

bool BatteryManager::isCharging() const {
    return m_isCharging;
}