 #ifndef CALENDAR_H
#define CALENDAR_H
#include <QObject>
#include <QVariantList>
#include <QDate>

class CalendarManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(int currentYear READ currentYear WRITE setCurrentYear NOTIFY currentYearChanged)
    Q_PROPERTY(int currentMonth READ currentMonth WRITE setCurrentMonth NOTIFY currentMonthChanged)
    Q_PROPERTY(QVariantList daysGrid READ daysGrid NOTIFY daysGridChanged)

public:

    explicit CalendarManager(QObject *parent = nullptr);
    Q_INVOKABLE void togglePopup() { emit popupToggled(); }
    int currentYear() const;
    void setCurrentYear(int year);
    int currentMonth() const;
    void setCurrentMonth(int month);

    QVariantList daysGrid() const;
    Q_INVOKABLE void nextMonth();
    Q_INVOKABLE void prevMonth();
    Q_INVOKABLE void goToToday();
    Q_INVOKABLE QVariantList getDaysForMonth(int year, int month);

    signals:

    void currentYearChanged();
    void currentMonthChanged();
    void daysGridChanged();
    void popupToggled();


private:
    void regenerateGrid();
    int m_currentYear;
    int m_currentMonth;
    QVariantList m_daysGrid; // array 42 unit (each QVariantMap contain: dayNumber, isCurrentMonth, isToday)

};


#endif