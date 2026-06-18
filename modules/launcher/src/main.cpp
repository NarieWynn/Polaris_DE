#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDirIterator>


using namespace Qt::StringLiterals;

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    const QUrl url(u"qrc:/polaris/qml/main.qml"_s);


    engine.load(url);

    return QGuiApplication::exec();
}
