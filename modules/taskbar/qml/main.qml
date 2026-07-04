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
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        height: 33
        width: leftSystemTray.width + 8
        radius: 14
        color: Qt.rgba(0, 0, 0, 0.6)
        //left
        Row {
            id: leftSystemTray
            anchors.centerIn: parent
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter

            WorkspaceIndicator {
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        height: 33
        width: rightSystemTray.width + 8
        radius: 14
        color: Qt.rgba(0, 0, 0, 0.6)
        //right
        Row {
            id: rightSystemTray
            spacing: 4
            anchors.centerIn: parent
            anchors.rightMargin: 4
            anchors.verticalCenter: parent.verticalCenter

            WifiIndicator {
                id: wifiWidget
                height: 26
            }

            Clock {
                id: clockWidget
                height: 26
            }

            DateDisplay {
                id: dateWidget
                height: 26
            }

            Battery {
                id: batteryWidget
                height: 26
            }
        }
    }
}