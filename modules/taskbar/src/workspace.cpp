#include "workspace.h"
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QProcess>
#include <QTimer>
WorkspaceManager::WorkspaceManager(QObject *parent) : QObject(parent) {
    m_socket = new QLocalSocket(this);
    connect(m_socket, &QLocalSocket::readyRead, this, &WorkspaceManager::onSocketData);
    connect(m_socket, &QLocalSocket::errorOccurred, this, &WorkspaceManager::onSocketError);
    fetchInitialData();
    connectToHyprland();
}

void WorkspaceManager::connectToHyprland() {
    QString signature = qEnvironmentVariable("HYPRLAND_INSTANCE_SIGNATURE");
    QString runtimeDir = qEnvironmentVariable("XDG_RUNTIME_DIR");
    QString socketPath = QString("%1/hypr/%2/.socket2.sock").arg(runtimeDir, signature);
    m_socket->connectToServer(socketPath);
}

void WorkspaceManager::fetchInitialData() {
    
    QProcess proc;
    proc.start("hyprctl", {"activeworkspace", "-j"});
    proc.waitForFinished();
    QJsonObject active = QJsonDocument::fromJson(proc.readAllStandardOutput()).object();
    m_activeWorkspace = active["id"].toInt();


    QProcess proc2;
    proc2.start("hyprctl", {"workspaces", "-j"});
    proc2.waitForFinished();
    QJsonArray workspaces = QJsonDocument::fromJson(proc2.readAllStandardOutput()).array();
    m_totalWorkspaces = workspaces.size();

    emit workspaceChanged();
}

void WorkspaceManager::onSocketData() {
    while (m_socket->canReadLine()) {
        QString line = m_socket->readLine().trimmed();

        if (line.startsWith("workspace>>")) {
            m_activeWorkspace = line.mid(11).toInt();
            emit workspaceChanged();
        } else if (line.startsWith("createworkspace>>") ||
                   line.startsWith("destroyworkspace>>")) {
            fetchInitialData();
        }
    }
}

void WorkspaceManager::onSocketError() {
    QTimer::singleShot(1000, this, &WorkspaceManager::connectToHyprland);
}

int WorkspaceManager::activeWorkspace() const { return m_activeWorkspace; }
int WorkspaceManager::totalWorkspaces() const { return m_totalWorkspaces; }