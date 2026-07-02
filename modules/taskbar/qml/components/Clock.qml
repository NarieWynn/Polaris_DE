import QtQuick

Item {
    id: root
    width: clockText.width
    height: parent ? parent.height : 0

    Text {
        id: clockText
        color: "white"
        font.pixelSize: 16
        anchors.centerIn: parent

        text: sysClock.timeText
    }
}