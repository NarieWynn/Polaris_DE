import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height
        clip: true

        Column {
            id: contentColumn
            width: parent.width - 40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 24

            Text {
                text: "Shortcuts"
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            // ================= CỤM 1: CORE SYSTEM =================
            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "󰘚  Core System"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: 90
                    radius: 12
                    color: Qt.rgba(1, 1, 1, 0.03)
                    border.color: Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Item {
                            width: parent.width; height: 20
                            Text { text: "Open Terminal"; color: Qt.rgba(1, 1, 1, 0.7); font.pixelSize: 13; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter }
                            Rectangle { width: 90; height: 22; radius: 4; color: Qt.rgba(1, 1, 1, 0.08); anchors.right: parent.right
                                Text { text: "SUPER + Q"; color: "#b5e8b0"; font.pixelSize: 11; font.bold: true; font.family: "JetBrainsMono Nerd Font"; anchors.centerIn: parent }
                            }
                        }

                        Rectangle { width: parent.width; height: 1; color: Qt.rgba(1, 1, 1, 0.05) }

                        Item {
                            width: parent.width; height: 20
                            Text { text: "App Launcher"; color: Qt.rgba(1, 1, 1, 0.7); font.pixelSize: 13; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter }
                            Rectangle { width: 100; height: 22; radius: 4; color: Qt.rgba(1, 1, 1, 0.08); anchors.right: parent.right
                                Text { text: "SUPER + SPACE"; color: "#b5e8b0"; font.pixelSize: 11; font.bold: true; font.family: "JetBrainsMono Nerd Font"; anchors.centerIn: parent }
                            }
                        }
                    }
                }
            }

            // ================= CỤM 2: WINDOW MANAGEMENT =================
            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "󰖲  Window Management"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: 130
                    radius: 12
                    color: Qt.rgba(1, 1, 1, 0.03)
                    border.color: Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Item {
                            width: parent.width; height: 20
                            Text { text: "Close Active Window"; color: Qt.rgba(1, 1, 1, 0.7); font.pixelSize: 13; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter }
                            Rectangle { width: 90; height: 22; radius: 4; color: Qt.rgba(1, 1, 1, 0.08); anchors.right: parent.right
                                Text { text: "SUPER + C"; color: "#ff8787"; font.pixelSize: 11; font.bold: true; font.family: "JetBrainsMono Nerd Font"; anchors.centerIn: parent }
                            }
                        }

                        Rectangle { width: parent.width; height: 1; color: Qt.rgba(1, 1, 1, 0.05) }

                        Item {
                            width: parent.width; height: 20
                            Text { text: "Toggle Window Floating"; color: Qt.rgba(1, 1, 1, 0.7); font.pixelSize: 13; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter }
                            Rectangle { width: 90; height: 22; radius: 4; color: Qt.rgba(1, 1, 1, 0.08); anchors.right: parent.right
                                Text { text: "SUPER + V"; color: "#b5e8b0"; font.pixelSize: 11; font.bold: true; font.family: "JetBrainsMono Nerd Font"; anchors.centerIn: parent }
                            }
                        }

                        Rectangle { width: parent.width; height: 1; color: Qt.rgba(1, 1, 1, 0.05) }

                        Item {
                            width: parent.width; height: 20
                            Text { text: "Move Focus (Arrows)"; color: Qt.rgba(1, 1, 1, 0.7); font.pixelSize: 13; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter }
                            Rectangle { width: 130; height: 22; radius: 4; color: Qt.rgba(1, 1, 1, 0.08); anchors.right: parent.right
                                Text { text: "SUPER + Left/Right"; color: "#b5e8b0"; font.pixelSize: 11; font.bold: true; font.family: "JetBrainsMono Nerd Font"; anchors.centerIn: parent }
                            }
                        }
                    }
                }
            }
        }
    }
}