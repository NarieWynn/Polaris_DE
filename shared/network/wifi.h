#pragma once
#include <QTimer>
#include <QList>
#include <QVariantList>
#include <QProcess>
#include <QVariantMap>

struct WifiNetwork {
    QString ssid;
    int signal;
    bool isConnected;
    bool isProtected;
};

class WifiManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString ssid READ ssid NOTIFY wifiChanged)
    Q_PROPERTY(int signalStrength READ signalStrength NOTIFY wifiChanged)
    Q_PROPERTY(bool isConnected READ isConnected NOTIFY wifiChanged)
    Q_PROPERTY(QVariantList networks READ networks NOTIFY networksChanged)
    Q_PROPERTY(bool isScanning READ isScanning NOTIFY scanningChanged)
    Q_PROPERTY(bool isWifiEnabled READ isWifiEnabled WRITE setWifiEnabled NOTIFY wifiEnabledChanged)

public:
    explicit WifiManager(QObject *parent = nullptr);
    ~WifiManager() override;

    [[nodiscard]] QString ssid() const;
    [[nodiscard]] int signalStrength() const;
    [[nodiscard]] bool isConnected() const;
    [[nodiscard]] QVariantList networks() const;
    [[nodiscard]] bool isScanning() const;
    [[nodiscard]] bool isWifiEnabled() const;

    Q_INVOKABLE void setWifiEnabled(bool enabled);
    Q_INVOKABLE void togglePopup();
    static Q_INVOKABLE void openPopup();
    Q_INVOKABLE void scan();
    Q_INVOKABLE void connectTo(const QString &ssid, const QString &password = "");
    Q_INVOKABLE void disconnect();
    // Get list of saved network profiles
    static Q_INVOKABLE QVariantList getSavedNetworks();
    // Remove a saved network profile
    Q_INVOKABLE void forgetNetwork(const QString &ssid);

signals:
    void wifiChanged();
    void networksChanged();
    void scanningChanged();
    void wifiEnabledChanged();
    void connectError(const QString &message);
    void popupToggled();

private slots:
    void updateWifi();

private:

    QProcess *m_scanProc = nullptr;
    QProcess *m_proc = nullptr;
    QProcess *m_connProc = nullptr;
    QProcess *m_disProc = nullptr;
    QTimer *m_timer = nullptr;

    QString m_ssid;
    int m_signalStrength = 0;
    bool m_isConnected = false;
    bool m_isScanning = false;
    bool m_isWifiEnabled = true;
    QVariantList m_networks;
};