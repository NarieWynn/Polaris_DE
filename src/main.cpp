#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDirIterator>
#include <QDebug>

using namespace Qt::StringLiterals;

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    qDebug() << "--- DANH SÁCH FILE QML ĐANG CÓ TRONG HỆ THỐNG QRC: ---";
    QDirIterator it(":", QDirIterator::Subdirectories);
    while (it.hasNext()) {
        QString path = it.next();
        if (path.endsWith(".qml")) {
            qDebug() << "-> Tìm thấy file QML tại:" << path;
        }
    }
    qDebug() << "----------------------------------------------------";


    QQmlApplicationEngine engine;

    const QUrl url(u"qrc:/polaris/qml/main.qml"_s);


    engine.load(url);

    return QGuiApplication::exec();
}
