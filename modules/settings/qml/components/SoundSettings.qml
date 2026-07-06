import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent
    property int currentVolume: (typeof sysHardware !== "undefined") ? sysHardware.volume : 75
    property bool isMuted: false

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
                text: "Sound"
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            // ================= 1. MASTER VOLUME =================
            Column {
                width: parent.width
                spacing: 12

                Row {
                    width: parent.width
                    spacing: 8

                    Text {
                        text: root.isMuted ? "󰝟  Volume (Muted)" : "󰕾  Volume"
                        color: root.isMuted ? "#ff6b6b" : "white"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }
                    Text {
                        text: root.isMuted ? "0%" : root.currentVolume + "%"
                        color: "#b5e8b0"
                        font.pixelSize: 14
                        font.bold: true
                    }
                }

                Row {
                    width: parent.width
                    spacing: 16

                    Rectangle {
                        id: muteBtn
                        width: 36
                        height: 36
                        radius: 8
                        color: root.isMuted ? Qt.rgba(1, 0.4, 0.4, 0.2) : Qt.rgba(1, 1, 1, 0.05)
                        border.color: root.isMuted ? "#ff6b6b" : "transparent"
                        border.width: 1
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn: parent
                            text: root.isMuted ? "󰝟" : "󰕾"
                            color: root.isMuted ? "#ff6b6b" : "white"
                            font.pixelSize: 16
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.isMuted = !root.isMuted
                        }
                    }

                    Slider {
                        id: volumeSlider
                        width: parent.width - muteBtn.width - 16
                        anchors.verticalCenter: parent.verticalCenter
                        to: 100
                        value: root.currentVolume
                        stepSize: 1
                        enabled: !root.isMuted
                        opacity: root.isMuted ? 0.4 : 1.0

                        onMoved: {
                            root.currentVolume = value
                            if (typeof sysHardware !== "undefined") {
                                sysHardware.volume = value
                            }
                        }

                        background: Rectangle {
                            x: volumeSlider.leftPadding
                            y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 6
                            width: volumeSlider.availableWidth
                            height: implicitHeight
                            radius: 3
                            color: Qt.rgba(1, 1, 1, 0.1)

                            Rectangle {
                                width: volumeSlider.visualPosition * parent.width
                                height: parent.height
                                color: "#b5e8b0"
                                radius: 3
                            }
                        }

                        handle: Rectangle {
                            x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                            y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                            implicitWidth: 16
                            implicitHeight: 16
                            radius: 8
                            color: "white"
                            border.color: "#b5e8b0"
                            border.width: 2
                        }
                    }
                }
            }

            // ================= 2. OUTPUT DEVICES =================
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "󰓃  Output Device"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Rectangle {
                    id: outputBox
                    width: parent.width
                    height: 45
                    radius: 10
                    color: Qt.rgba(1, 1, 1, 0.03)
                    border.color: Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Item {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16

                        Text {
                            id: outputIcon
                            text: "󰓃"
                            color: "#b5e8b0"
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "Built-in Audio Speaker (LOQ Laptop)"
                            color: "white"
                            font.pixelSize: 13
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: outputIcon.right
                            anchors.leftMargin: 12
                        }

                        Text {
                            text: ""
                            color: "white"
                            font.pixelSize: 12
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                        }
                    }
                }
            }

            // ================= 3. INPUT DEVICES =================
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "󰍬  Input Device (Microphone)"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: 75
                    radius: 12
                    color: Qt.rgba(1, 1, 1, 0.03)
                    border.color: Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 8

                        Text {
                            text: "󰍬  Digital Microphone"
                            color: "white"
                            font.pixelSize: 13
                        }

                        Rectangle {
                            width: parent.width
                            height: 6
                            radius: 3
                            color: Qt.rgba(1, 1, 1, 0.1)

                            Rectangle {
                                width: parent.width * 0.35
                                height: parent.height
                                color: "#6bffb5"
                                radius: 3
                            }
                        }
                    }
                }
            }

            // ================= 4. APPLICATION VOLUME =================
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "󰅖  App Volumes"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: 50
                    radius: 10
                    color: Qt.rgba(1, 1, 1, 0.02)

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 16

                        Text { text: ""; color: "#1DB954"; font.pixelSize: 16; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: "Spotify"; color: "white"; font.pixelSize: 13; width: 60; anchors.verticalCenter: parent.verticalCenter }

                        Slider {
                            id: appSlider
                            width: parent.width - 120
                            anchors.verticalCenter: parent.verticalCenter
                            value: 80
                            to: 100
                        }
                    }
                }
            }
        }
    }
}