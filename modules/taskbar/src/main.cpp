#include <LayerShellQt/window.h>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include "clock.h"
#include "battery.h"
#include "workspace.h"
#include <wifi.h>
#include <QSize>
#include "calendar.h"

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
    CalendarManager calendar;
    engine.rootContext()->setContextProperty("sysCalendar", &calendar);
    // Load window
    engine.load(u"qrc:/qt/qml/polaris/qml/main.qml"_s);
    engine.load(u"qrc:/qt/qml/polaris/qml/WifiPopupWindow.qml"_s);
    engine.load(u"qrc:/qt/qml/polaris/qml/CalendarPopupWindow.qml"_s);

    // Set layer-shell for all window
    QQuickWindow *popupWindow = nullptr;
    QQuickWindow *calendarWindow = nullptr;
    auto objects = engine.rootObjects();

    for (auto *obj : objects) {
        auto *window = qobject_cast<QQuickWindow*>(obj);
        if (!window) continue;

        auto *layerWindow = LayerShellQt::Window::get(window);

        if (window->title() == "taskbar") {
            layerWindow->setLayer(LayerShellQt::Window::LayerTop);
            layerWindow->setAnchors(
                LayerShellQt::Window::Anchors(
                    LayerShellQt::Window::AnchorTop |
                    LayerShellQt::Window::AnchorLeft |
                    LayerShellQt::Window::AnchorRight
                )
            );
            layerWindow->setMargins(QMargins(0, 2, 0, 0));
            layerWindow->setExclusiveZone(25);
            layerWindow->setDesiredSize(QSize(0, 25));
            window->show();

        } else if (window->title() == "wifi_popup") {
            popupWindow = window;
            layerWindow->setLayer(LayerShellQt::Window::LayerTop);
            layerWindow->setAnchors(
                LayerShellQt::Window::Anchors(
                    LayerShellQt::Window::AnchorTop |
                    LayerShellQt::Window::AnchorRight
                )
            );
            layerWindow->setMargins(QMargins(0, 25, 0, 0));
            layerWindow->setExclusiveZone(-1);
            layerWindow->setDesiredSize(QSize(240, 300));
            layerWindow->setKeyboardInteractivity(
                LayerShellQt::Window::KeyboardInteractivityOnDemand
            );
        }else if (window->title() == "calendar_popup") {
            calendarWindow = window;
            layerWindow->setLayer(LayerShellQt::Window::LayerTop);
            layerWindow->setAnchors(
                LayerShellQt::Window::Anchors(
                    LayerShellQt::Window::AnchorTop
                )
            );
            layerWindow->setMargins(QMargins(0, 25, 0, 0));
            layerWindow->setExclusiveZone(-1);
            layerWindow->setDesiredSize(QSize(320, 380));
            layerWindow->setKeyboardInteractivity(
                LayerShellQt::Window::KeyboardInteractivityOnDemand
            );
        }
    }


    // Connect signal toggle popup
    if (popupWindow) {
        QObject::connect(&wifi, &WifiManager::popupToggled, [popupWindow]() {
            popupWindow->setVisible(!popupWindow->isVisible());
        });
    }

    if (calendarWindow) {
        QObject::connect(&calendar, &CalendarManager::popupToggled, [calendarWindow]() {
            calendarWindow->setVisible(!calendarWindow->isVisible());
        });
    }

    return QGuiApplication::exec();
}