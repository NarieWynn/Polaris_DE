import QtQuick

Rectangle {
    id: root
    width: clockColumn.width + 16
    height: parent ? parent.height : 0
    color: Qt.rgba(0.71, 0.91, 0.69, 0.7)
    radius: 10

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