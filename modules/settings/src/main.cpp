#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickWindow>

using namespace Qt::StringLiterals;

int main(int argc, char *argv[]) {
#ifdef HAS_VULKAN
    qputenv("QSG_RHI_BACKEND", "vulkan");
#endif
    QQuickWindow::setDefaultAlphaBuffer(true);  

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    const QUrl url(u"qrc:/qt/qml/polaris/qml/main.qml"_s);
    engine.load(url);
    return QGuiApplication::exec();
}