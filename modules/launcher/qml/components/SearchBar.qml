import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

TextField {
    id: searchInput
    Layout.fillWidth: true
    Layout.preferredHeight: 36

    color: "white"
    font.pixelSize: 16
    font.family: "JetBrainsMono Nerd Font"
    font.bold: false

    placeholderText: "Search apps or type > for terminal..."
    placeholderTextColor: Qt.rgba(1, 1, 1, 0.35)

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    verticalAlignment: TextInput.AlignVCenter

    selectByMouse: true
    selectionColor: Qt.rgba(0.71, 0.91, 0.69, 0.35)

    cursorDelegate: Rectangle {
        width: 2
        color: "#b5e8b0"
    }

    background: Rectangle {
        color: "transparent"
    }
}