#include <network/wifi.h>
#include <QQmlApplicationEngine>
#include <QQuickWindow>
#include <QQmlContext>
#include <hardware/hardwareInterface.h>

using namespace Qt::StringLiterals;

int main(int argc, char *argv[]) {
#ifdef HAS_VULKAN
    qputenv("QSG_RHI_BACKEND", "vulkan");
#endif
    QQuickWindow::setDefaultAlphaBuffer(true);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    HardwareInterface hardware;
    engine.rootContext()->setContextProperty("sysHardware", &hardware);
    WifiManager wifi;
    engine.rootContext()->setContextProperty("sysWifi", &wifi);
    
    const QUrl url(u"qrc:/qt/qml/polaris/qml/main.qml"_s);
    engine.load(url);
    return QGuiApplication::exec();
}