import QtQuick

Item {
    id: root
    implicitWidth: clockRow.width
    implicitHeight: clockRow.height

    Row {
        id: clockRow
        anchors.centerIn: parent
        spacing: 6

        Text {
            text: sysClock.dateText
            color: Qt.rgba(1, 1, 1, 0.5)
            font.pixelSize: 12
            font.family: "JetBrainsMono Nerd Font"
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: 1
            height: 12
            color: Qt.rgba(0.71, 0.91, 0.69, 0.25)
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: sysClock.timeText
            color: clockMouseArea.containsMouse ? "#b5e8b0" : "white"
            font.pixelSize: 12
            font.bold: true
            font.family: "JetBrainsMono Nerd Font"
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    MouseArea {
        id: clockMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: sysCalendar.togglePopup()
    }
}