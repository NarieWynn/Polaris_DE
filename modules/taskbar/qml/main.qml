import QtQuick
import QtQuick.Controls
import "components"

Window {
    id: root
    width: Screen.width
    height: 30
    visible: false
    title: "taskbar"
    color: "transparent"



    Row {
        id: rightSystemTray
        spacing: 4
        anchors.right: parent.right
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter

        Clock {
            id: clockWidget
            height: 26
        }

        DateDisplay{
            id: dateWidget
            height: 26
        }
        Battery {
            id: batteryWidget
            height: 26
        }
    }
}