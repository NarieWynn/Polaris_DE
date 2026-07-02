import QtQuick
import QtQuick.Controls
import "components"
Window {
    id: root
    width: Screen.width
    height: 40
    visible: true
    title: "taskbar"
    color: "#1e1e2e"

    Clock{
        id: clock
        width: 50
        height: parent.height

        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
    }
}
