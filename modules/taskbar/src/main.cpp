#include <LayerShellQt/window.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include "clock.h"
#include "battery.h"
#include <QSize>
#include "workspace.h"
#include "wifi.h"
using namespace Qt::StringLiterals;

int main(int argc, char *argv[]) {
#ifdef HAS_VULKAN
    qputenv("QSG_RHI_BACKEND", "vulkan");
#endif

    QQuickWindow::setDefaultAlphaBuffer(true);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    Clock clock;
    engine.rootContext()->setContextProperty("sysClock", &clock);

    BatteryManager battery;
    engine.rootContext()->setContextProperty("sysBattery", &battery);

    WorkspaceManager workspace;
    engine.rootContext()->setContextProperty("sysWorkspace", &workspace);

    WifiManager wifi;
    engine.rootContext()->setContextProperty("sysWifi", &wifi);

    const QUrl url(u"qrc:/qt/qml/polaris/qml/main.qml"_s);
    engine.load(url);

    if (!engine.rootObjects().isEmpty()) {
        auto *window = qobject_cast<QQuickWindow*>(engine.rootObjects().first());
        if (window) {
            auto *layerWindow = LayerShellQt::Window::get(window);
            layerWindow->setLayer(LayerShellQt::Window::LayerTop);
            layerWindow->setAnchors(
                LayerShellQt::Window::Anchors(
                    LayerShellQt::Window::AnchorTop |
                    LayerShellQt::Window::AnchorLeft |
                    LayerShellQt::Window::AnchorRight
                )
            );
            layerWindow->setExclusiveZone(30);
            layerWindow->setDesiredSize(QSize(0, 30));
            window->show();
        }
    }

    return QGuiApplication::exec();
}