import QtQuick
import QtQuick.Controls
import "components"

Window {
    id: calendarRoot
    title: "calendar_popup"
    width: 320
    height: 380
    visible: false
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint

    Rectangle {
        id: bgCard
        anchors.fill: parent
        color: Qt.rgba(0.03, 0.05, 0.04, 0.94)
        radius: 20
        border.color: Qt.rgba(0.71, 0.91, 0.69, 0.18)
        border.width: 1

        CalendarView {
            anchors.fill: parent
            anchors.margins: 16
            onCloseClicked: sysCalendar.togglePopup()
        }
    }
}