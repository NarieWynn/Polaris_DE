#pragma once
#include <QTimer>
#include <QList>
#include <QVariantList>
#include <QProcess>

struct WifiNetwork {
    QString ssid;
    int signal;
    bool isConnected;
};

class WifiManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString ssid READ ssid NOTIFY wifiChanged)
    Q_PROPERTY(int signalStrength READ signalStrength NOTIFY wifiChanged)
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY wifiChanged)
    Q_PROPERTY(QVariantList networks READ networks NOTIFY networksChanged)
    Q_PROPERTY(bool isScanning READ isScanning NOTIFY scanningChanged)

public:
    explicit WifiManager(QObject *parent = nullptr);
    QString ssid() const;
    int signalStrength() const;
    bool isConnected() const;
    QVariantList networks() const;
    bool isScanning() const;

    Q_INVOKABLE void togglePopup();
    static Q_INVOKABLE void openPopup();
    Q_INVOKABLE void scan();
    Q_INVOKABLE void connectTo(const QString &ssid, const QString &password = "");
    Q_INVOKABLE void disconnect();

    signals:
    void wifiChanged();
    void networksChanged();
    void scanningChanged();
    void connectError(const QString &message);
    void popupToggled();

private slots:
    void updateWifi();

private:
    QProcess *m_scanProc = nullptr;
    QTimer *m_timer;
    QString m_ssid;
    int m_signalStrength = 0;
    bool m_isConnected = false;
    bool m_isScanning = false;
    QVariantList m_networks;
    QProcess *m_proc = nullptr;
};