#pragma once
#include <QLocalSocket>

class WorkspaceManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(int activeWorkspace READ activeWorkspace NOTIFY workspaceChanged)
    Q_PROPERTY(int totalWorkspaces READ totalWorkspaces NOTIFY workspaceChanged)

public:
    explicit WorkspaceManager(QObject *parent = nullptr);
    [[nodiscard]] int activeWorkspace() const;
    [[nodiscard]] int totalWorkspaces() const;

    signals:
        void workspaceChanged();

private slots:
    void onSocketData();
    void onSocketError();

private:
    void connectToHyprland();
    void fetchInitialData();

    QLocalSocket *m_socket;
    int m_activeWorkspace = 1;
    int m_totalWorkspaces = 1;
};