import QtQuick
import QtQuick.Controls
import "components"

Window {
    id: root
    width: 800
    height: 560
    title: "Settings"
    color: "transparent"
    visible: true

    property string currentTab: "wifi"

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Qt.rgba(0, 0, 0, 0.75)
        border.color: Qt.rgba(0.71, 0.91, 0.69, 0.2)
        border.width: 1

        // Title bar
        Rectangle {
            id: titleBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 44
            radius: 16
            color: "transparent"

            // Fake bo góc dưới của title bar
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 16
                color: "transparent"
            }

            Text {
                anchors.centerIn: parent
                text: "Settings"
                color: "#b5e8b0"
                font.pixelSize: 14
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
            }

            // Nút đóng
            Rectangle {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 16
                width: 12
                height: 12
                radius: 6
                color: closeBtn.containsMouse ? "#ff6b6b" : Qt.rgba(1, 0.4, 0.4, 0.5)

                MouseArea {
                    id: closeBtn
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: Qt.quit()
                }
            }

            // Drag to move
            MouseArea {
                anchors.fill: parent
                anchors.rightMargin: 40
                onPressed: root.startSystemMove()
            }
        }

        // Divider
        Rectangle {
            anchors.top: titleBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(0.71, 0.91, 0.69, 0.15)
        }

        Row {
            anchors.top: titleBar.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 1

            // Sidebar
            Rectangle {
                width: parent.width * 0.28
                height: parent.height
                color: Qt.rgba(0, 0, 0, 0.3)
                radius: 16

                // Bo góc chỉ bên trái
                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    width: 16
                    color: Qt.rgba(0, 0, 0, 0.3)
                }

                Column {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    Repeater {
                        model: [
                            { id: "wifi",    label: "󰖩  Wi-Fi" },
                            { id: "sound",   label: "󰕾  Sound" },
                            { id: "display", label: "󰍹  Display" }
                        ]

                        Rectangle {
                            width: parent.width
                            height: 44
                            radius: 10
                            color: currentTab === modelData.id
                                ? Qt.rgba(0.71, 0.91, 0.69, 0.15)
                                : tabMouse.containsMouse
                                    ? Qt.rgba(1, 1, 1, 0.05)
                                    : "transparent"

                            // Indicator bar bên trái
                            Rectangle {
                                visible: currentTab === modelData.id
                                width: 3
                                height: 20
                                radius: 2
                                color: "#b5e8b0"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 2
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 16
                                text: modelData.label
                                color: currentTab === modelData.id
                                    ? "#b5e8b0"
                                    : Qt.rgba(1, 1, 1, 0.6)
                                font.pixelSize: 13
                                font.family: "JetBrainsMono Nerd Font"
                            }

                            MouseArea {
                                id: tabMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: currentTab = modelData.id
                            }
                        }
                    }
                }
            }

            // Content
            Rectangle {
                width: parent.width * 0.72
                height: parent.height
                color: "transparent"

                Loader {
                    anchors.fill: parent
                    anchors.margins: 20
                    source: currentTab === "wifi" ? "components/WifiSettings.qml" :
                            currentTab === "sound" ? "components/SoundSettings.qml" :
                                currentTab === "display" ? "components/DisplaySettings.qml" : ""
                }
            }
        }
    }
}