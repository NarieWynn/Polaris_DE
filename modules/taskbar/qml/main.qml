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

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.5)  // thêm nền tạm để thấy rõ size
    }

    Row {
        id: rightSystemTray
        spacing: 16
        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter

        Clock {
            id: clockWidget
            anchors.verticalCenter: parent.verticalCenter
        }

        Battery {
            id: batteryWidget
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}