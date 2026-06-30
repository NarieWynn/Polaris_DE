#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDirIterator>
#include "appmodel.h"
#include <QQmlContext>
#include <QSettings>
void testReadApps()
{
    QDirIterator it("/usr/share/applications", QStringList() << "*.desktop", QDir::Files);
    while (it.hasNext()) {
        QString path = it.next();

        QSettings desktopFile(path, QSettings::IniFormat);
        desktopFile.beginGroup("Desktop Entry");

        QString name = desktopFile.value("Name").toString();

        qDebug() << name;

        desktopFile.endGroup();
    }
}
using namespace Qt::StringLiterals;

int main(int argc, char *argv[]) {

#ifdef HAS_VULKAN
    qputenv("QSG_RHI_BACKEND", "vulkan");
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    const QUrl url(u"qrc:/qt/qml/polaris/qml/main.qml"_s);
    AppModel model;
    engine.rootContext()->setContextProperty("appModel", &model);
    testReadApps();
    engine.load(url);

    return QGuiApplication::exec();
}
