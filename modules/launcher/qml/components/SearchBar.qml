import QtQuick
import QtQuick.Controls

TextField {
    id: searchInput

    width: parent.width - 64
    height: 44
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 16

    color: Qt.rgba(0, 0, 0, 1)
    font.bold: true
    font.pixelSize: 14
    font.family: "JetBrainsMono Nerd Font"
    placeholderText: "🔍 Search or type > for terminal..."
    placeholderTextColor: Qt.rgba(0, 0, 0, 0.4)

    leftPadding: 20
    rightPadding: 20
    verticalAlignment: TextInput.AlignVCenter
    
    background: Rectangle {
        width: parent.width
        height: parent.height
        radius: height / 2
        color: Qt.rgba(255, 255, 255, 0.85)
        border.color: Qt.rgba(255, 255, 255, 0.2)
        border.width: 1
    }
}