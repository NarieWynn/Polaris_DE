#pragma once
#include <QDBusInterface>
#include <QTimer>

class WifiManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString ssid READ ssid NOTIFY wifiChanged)
    Q_PROPERTY(int signalStrength READ signalStrength NOTIFY wifiChanged)
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY wifiChanged)
public:
    explicit WifiManager(QObject *parent = nullptr);
    Q_INVOKABLE void openPopup();
    [[nodiscard]] QString ssid() const;
    [[nodiscard]] int signalStrength() const;
    [[nodiscard]] bool isConnected() const;

    signals:
        void wifiChanged();

private slots:
    void updateWifi();

private:
    QTimer *m_timer;
    QString m_ssid;
    int m_signalStrength = 0;
    bool m_isConnected = false;
};