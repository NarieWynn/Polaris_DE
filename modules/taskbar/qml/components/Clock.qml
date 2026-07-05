import QtQuick

Rectangle {
    id: root
    width: clockColumn.width + 16
    height: parent ? parent.height : 0

    color: clockMouseArea.containsMouse ? Qt.rgba(0.81, 1.0, 0.79, 0.85) : Qt.rgba(0.71, 0.91, 0.69, 0.7)
    radius: 10

    Behavior on color {
        ColorAnimation { duration: 150 }
    }

    MouseArea {
        id: clockMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            sysCalendar.togglePopup()
        }
    }

    Row {
        id: clockColumn
        spacing: 4
        anchors.centerIn: parent

        Text {
            id: dateTextDisplay
            text: sysClock.dateText
            color: "#2d5a27"
            font.bold: true
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: timeTextDisplay
            text: sysClock.timeText
            color: "#2d5a27"
            font.pixelSize: 12
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}