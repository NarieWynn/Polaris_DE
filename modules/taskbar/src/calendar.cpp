#include "calendar.h"
#include <QVariantMap>

CalendarManager::CalendarManager(QObject *parent)
    : QObject(parent)
{

    QDate today = QDate::currentDate();
    m_currentYear = today.year();
    m_currentMonth = today.month();

    regenerateGrid();
}


int CalendarManager::currentYear() const {
    return m_currentYear;
}

void CalendarManager::setCurrentYear(int year) {
    if (m_currentYear != year) {
        m_currentYear = year;
        emit currentYearChanged();
        regenerateGrid();
    }
}

int CalendarManager::currentMonth() const {
    return m_currentMonth;
}

void CalendarManager::setCurrentMonth(int month) {
    if (m_currentMonth != month) {
        m_currentMonth = month;
        emit currentMonthChanged();
        regenerateGrid();
    }
}

QVariantList CalendarManager::daysGrid() const {
    return m_daysGrid;
}

void CalendarManager::nextMonth() {
    if (m_currentMonth == 12) {
        m_currentMonth = 1;
        m_currentYear++;
        emit currentYearChanged();
    } else {
        m_currentMonth++;
    }
    emit currentMonthChanged();
    regenerateGrid();
}

void CalendarManager::prevMonth() {
    if (m_currentMonth == 1) {
        m_currentMonth = 12;
        m_currentYear--;
        emit currentYearChanged();
    } else {
        m_currentMonth--;
    }
    emit currentMonthChanged();
    regenerateGrid();
}

void CalendarManager::goToToday() {
    QDate today = QDate::currentDate();
    bool yearChanged = (m_currentYear != today.year());
    bool monthChanged = (m_currentMonth != today.month());

    m_currentYear = today.year();
    m_currentMonth = today.month();

    if (yearChanged) emit currentYearChanged();
    if (monthChanged) emit currentMonthChanged();

    regenerateGrid();
}

QVariantList CalendarManager::getDaysForMonth(int year, int month) {
    QVariantList grid;
    QDate today = QDate::currentDate();

    QDate firstDayOfMonth(year, month, 1);

    int offset = firstDayOfMonth.dayOfWeek() - 1;

    QDate startDate = firstDayOfMonth.addDays(-offset);

    int daysInMonth = firstDayOfMonth.daysInMonth();
    int totalCells = (offset + daysInMonth <= 35) ? 35 : 42;

    for (int i = 0; i < totalCells; ++i) {
        QDate currentDate = startDate.addDays(i);
        QVariantMap cell;

        cell["dayNumber"] = currentDate.day();

        cell["isCurrentMonth"] = (currentDate.month() == month && currentDate.year() == year);

        cell["isToday"] = (currentDate == today);

        cell["dateString"] = currentDate.toString("yyyy-MM-dd");

        grid.append(cell);
    }

    return grid;
}

void CalendarManager::regenerateGrid() {
    m_daysGrid = getDaysForMonth(m_currentYear, m_currentMonth);
    emit daysGridChanged();
}