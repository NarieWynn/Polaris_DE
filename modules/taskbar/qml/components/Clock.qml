import QtQuick

Rectangle {
    id: root
    width: clockColumn.width + 16
    height: parent ? parent.height : 0
    color: Qt.rgba(0.71, 0.91, 0.69, 0.7)
    radius: 10

    Column {
        id: clockColumn

        anchors.centerIn: parent

        Text {
            id: timeTextDisplay
            text: sysClock.timeText
            color: "#2d5a27"
            font.pixelSize: 12
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}