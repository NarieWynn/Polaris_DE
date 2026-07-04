#include <LayerShellQt/shell.h>
#include <LayerShellQt/window.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <wifi.h>

using namespace Qt::StringLiterals;

int main(int argc, char *argv[]) {
    QQuickWindow::setDefaultAlphaBuffer(true);
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

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
                    LayerShellQt::Window::AnchorRight
                )
            );
            layerWindow->setMargins(QMargins(0, 30, 0, 0));
            layerWindow->setExclusiveZone(-1); // không đẩy window khác
            layerWindow->setDesiredSize(QSize(240, 300));
            layerWindow->setKeyboardInteractivity(LayerShellQt::Window::KeyboardInteractivityOnDemand);
            layerWindow->setCloseOnDismissed(true);
            window->show();
        }
    }

    return QGuiApplication::exec();
}