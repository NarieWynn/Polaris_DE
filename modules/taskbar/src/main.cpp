#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "clock.h"
#include <QQmlContext>

using namespace Qt::StringLiterals;

int main(int argc, char *argv[]) {

#ifdef HAS_VULKAN
    qputenv("QSG_RHI_BACKEND", "vulkan");
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    const QUrl url(u"qrc:/qt/qml/polaris/qml/main.qml"_s);

    Clock clock;
    engine.rootContext()->setContextProperty("sysClock", &clock);


    engine.load(url);

    return QGuiApplication::exec();
}
