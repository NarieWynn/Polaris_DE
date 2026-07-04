
import QtQuick

Rectangle {
    id: root
    width: dateColumn.width + 16
    height: parent ? parent.height : 0
    color: Qt.rgba(0.71, 0.91, 0.69, 0.7)
    radius: 10

    Column {
        id: dateColumn

        anchors.centerIn: parent

        Text {
            id: dateTextDisplay
            text: sysClock.dateText
            color: "#2d5a27"
            font.bold: true
            font.pixelSize: 12
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

