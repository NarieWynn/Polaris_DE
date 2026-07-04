import QtQuick
import QtQuick.Controls
import "components"

Window {
    id: root
    width: Screen.width
    height: 25
    visible: false
    title: "taskbar"
    color: "transparent"

    //left system tray
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.verticalCenter: parent.verticalCenter

        height: 25
        width: leftSystemTray.childrenRect.width + 16
        radius: 10
        color: Qt.rgba(0, 0, 0, 0.6)

        Row {
            id: leftSystemTray
            anchors.centerIn: parent

            WorkspaceIndicator {
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    //mid system tray
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        height: 25
        width: midSystemTray.childrenRect.width + 16
        radius: 10
        color: Qt.rgba(0, 0, 0, 0.6)

        Row {
            id: midSystemTray
            anchors.centerIn: parent
            spacing: 8

            Clock {
                id: clockWidget
                height: 23
            }
        }
    }
    //right system tray
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter

        height: 25
        width: rightSystemTray.childrenRect.width + 16
        radius: 10
        color: Qt.rgba(0, 0, 0, 0.6)

        Row {
            id: rightSystemTray
            spacing: 8
            anchors.centerIn: parent

            WifiIndicator {
                id: wifiWidget
                height: 23
            }
            Battery {
                id: batteryWidget
                height: 23
            }
        }
    }
}