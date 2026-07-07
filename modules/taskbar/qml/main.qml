import QtQuick
import "components"

Window {
    id: root
    width: Screen.width
    height: 44
    visible: false
    title: "taskbar"
    color: "transparent"

    // floating
    property int floatMargin: 2
    property int pillHeight: 25
    
    component GlassPill: Rectangle {
        radius: height / 2
        color: Qt.rgba(0.03, 0.05, 0.04, 0.75)
        border.color: Qt.rgba(0.71, 0.91, 0.69, 0.16)
        border.width: 1
    }

    //=================================================
    // LEFT: Workspace indicator
    //=================================================
    GlassPill {
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.top: parent.top
        anchors.topMargin: root.floatMargin
        height: root.pillHeight
        width: leftSystemTray.childrenRect.width + 20

        Row {
            id: leftSystemTray
            anchors.centerIn: parent
            spacing: 6

            WorkspaceIndicator {
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    //=================================================
    // MID: Clock
    //=================================================
    GlassPill {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: root.floatMargin
        height: root.pillHeight
        width: midSystemTray.childrenRect.width + 24

        Row {
            id: midSystemTray
            anchors.centerIn: parent
            spacing: 8

            Text {
                text: "\uf017" // nf-fa-clock
                color: "#b5e8b0"
                font.pixelSize: 12
                font.family: "JetBrainsMono Nerd Font"
                anchors.verticalCenter: parent.verticalCenter
            }

            Clock {
                id: clockWidget
                height: root.pillHeight - 4
            }
        }
    }

    //=================================================
    // RIGHT: Wifi + Battery
    //=================================================
    GlassPill {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.top: parent.top
        anchors.topMargin: root.floatMargin
        height: root.pillHeight
        width: rightSystemTray.childrenRect.width + 20

        Row {
            id: rightSystemTray
            anchors.centerIn: parent
            spacing: 10

            WifiIndicator {
                id: wifiWidget
                height: root.pillHeight - 4
            }

            Rectangle {
                width: 1
                height: 14
                anchors.verticalCenter: parent.verticalCenter
                color: Qt.rgba(0.71, 0.91, 0.69, 0.15)
            }

            Battery {
                id: batteryWidget
                height: root.pillHeight - 4
            }
        }
    }
}