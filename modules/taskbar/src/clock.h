#pragma once
#include <QTimer>
#include <QDateTime>

class Clock : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString timeText READ timeText NOTIFY timeChanged)
public:
    explicit Clock(QObject *parent = nullptr);

    [[nodiscard]] QString timeText() const;

signals:
    void timeChanged();

private slots:
    void updateTime();

private:
    QTimer* m_timer;
    QString m_currentTime;
};
