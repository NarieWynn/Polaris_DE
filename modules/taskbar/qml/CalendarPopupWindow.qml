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
        color: "#b31b241c"
        radius: 14
        border.color: "#33719169"
        border.width: 1

        CalendarView {
            anchors.fill: parent
            anchors.margins: 16
            onCloseClicked: sysCalendar.togglePopup()
        }
    }
}