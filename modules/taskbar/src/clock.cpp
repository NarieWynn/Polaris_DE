#include "clock.h"
#include <QObject>


Clock::Clock(QObject *parent):QObject(parent)
{
    m_timer = new QTimer(this);
    connect(m_timer, &QTimer::timeout, this, &Clock::updateTime);
    m_timer->start(1000);
    updateTime();
}

void Clock::updateTime() {
    m_currentTime = QDateTime::currentDateTime().toString("hh:mm");
    emit timeChanged();
}
QString Clock::timeText() const {
    return m_currentTime;
}
