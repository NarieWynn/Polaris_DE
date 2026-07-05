#pragma once
#include <QVariantMap>
#include <QStringList>

class CommandInterpreter : public QObject {
    Q_OBJECT
    Q_PROPERTY(QStringList history READ history NOTIFY historyChanged)
    Q_PROPERTY(bool waitingForConfirm READ waitingForConfirm NOTIFY waitingForConfirmChanged)

public:
    explicit CommandInterpreter(QObject *parent = nullptr);
    [[nodiscard]] QStringList history() const;
    [[nodiscard]] bool waitingForConfirm() const;
    Q_INVOKABLE void execute(const QString &input);
    static Q_INVOKABLE QVariantMap parse(const QString &input);

    signals:
    void resultText(const QString &text);
    void commandType(const QString &type, const QVariantMap &data);
    void historyChanged();
    void waitingForConfirmChanged();

private:
    void handleVolume(const QStringList &args);
    void handleBrightness(const QStringList &args);
    static void runViaShell(const QString &command);
    void handleCreate(const QStringList &args);

    void handleFind(const QStringList &args);
    QStringList m_history;
    bool m_waitingForConfirm = false;
    QString m_pendingAction;
    QStringList m_pendingArgs;
};