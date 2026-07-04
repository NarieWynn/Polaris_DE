
import QtQuick

Rectangle {
    id: root
    width: dateColumn.width + 16
    height: parent ? parent.height : 0
    color: "#b5e8b0"
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

