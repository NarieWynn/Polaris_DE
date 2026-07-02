#include "appmodel.h"
#include <QDirIterator>
#include <QSettings>
#include <QStandardPaths>
#include <QProcess>
#include <QRegularExpression>
void AppModel::launchApp(const QString &exec)
{
    QString cleanExec = exec;

    static const QRegularExpression regex("%[a-zA-Z]");


    cleanExec.remove(regex);
    cleanExec = cleanExec.trimmed();
    QProcess::startDetached("/bin/sh", {"-c", cleanExec});
}
AppModel::AppModel(QObject *parent):QAbstractListModel(parent)
{
    loadApps();
}

void AppModel::loadApps()
{

    QStringList appDirs = QStandardPaths::standardLocations(
        QStandardPaths::ApplicationsLocation
    );

    for (const QString &dir : appDirs) {
        QDirIterator it(dir, QStringList() << "*.desktop", QDir::Files);
        while (it.hasNext()) {
            QString path = it.next();
            QSettings desktopFile(path, QSettings::IniFormat);
            desktopFile.beginGroup("Desktop Entry");


            if (desktopFile.value("Type").toString() != "Application") {
                desktopFile.endGroup();
                continue;
            }


            if (desktopFile.value("NoDisplay", false).toBool()) {
                desktopFile.endGroup();
                continue;
            }

            AppInfo info;
            info.name = desktopFile.value("Name").toString();
            info.exec = desktopFile.value("Exec").toString();
            info.icon = desktopFile.value("Icon").toString();


            if (!info.name.isEmpty()) {
                m_apps.append(info);
            }

            desktopFile.endGroup();
        }
    }
}

int AppModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return static_cast<int>(m_apps.count());
}

QVariant AppModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_apps.count())
        return {};

    const AppInfo &app = m_apps.at(index.row());

    switch (role) {
        case NameRole: return app.name;
        case ExecRole: return app.exec;
        case IconRole: return app.icon;
        default: return {};
    }
}

QHash<int, QByteArray> AppModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[ExecRole] = "exec";
    roles[IconRole] = "icon";
    return roles;
}