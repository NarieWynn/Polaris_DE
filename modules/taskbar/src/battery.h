#ifndef BATTERY_H
#define BATTERY_H
#include <QTimer>

class BatteryManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(int batteryLevel READ batteryLevel NOTIFY batteryChanged)
    Q_PROPERTY(bool isCharging READ isCharging NOTIFY batteryChanged)

public:
    explicit BatteryManager(QObject *parent = nullptr);

    [[nodiscard]] int batteryLevel() const;
    [[nodiscard]] bool isCharging() const;

    signals:
        void batteryChanged();

private slots:

    void updateBatteryStatus();

private:
    int m_batteryLevel = 0;
    bool m_isCharging = false;
    QTimer *m_timer;
};

#endif