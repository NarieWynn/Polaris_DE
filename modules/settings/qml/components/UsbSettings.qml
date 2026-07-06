import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    property string usbStatus: "unmounted"
    property bool isFormatting: false

    // 🌟 Các biến quản lý tính năng Ventoy Bootable
    property bool isInstallingVentoy: false
    property real ventoyProgress: 0.0

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
                text: "USB & Disks"
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            // ================= 1. Connected Drives =================
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "󰋊  Connected Drives"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: 80
                    radius: 12
                    color: Qt.rgba(1, 1, 1, 0.03)
                    border.color: root.usbStatus === "mounted" ? Qt.rgba(0.71, 0.91, 0.69, 0.2) : Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Item {
                        anchors.fill: parent
                        anchors.margins: 16

                        Text {
                            id: usbIcon
                            text: "󱊞"
                            color: root.usbStatus === "mounted" ? "#b5e8b0" : "white"
                            font.pixelSize: 32
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            anchors.left: usbIcon.right
                            anchors.leftMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text: "Kingston DataTraveler 3.0"
                                color: "white"
                                font.pixelSize: 14
                                font.bold: true
                            }
                            Text {
                                text: "32 GB (/dev/sdb1) • " + (root.usbStatus === "mounted" ? "Mounted on /run/media/usb" : "Not Mounted")
                                color: Qt.rgba(1, 1, 1, 0.4)
                                font.pixelSize: 11
                            }
                        }

                        Button {
                            id: mountBtn
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 90
                            height: 32

                            contentItem: Text {
                                text: root.usbStatus === "mounted" ? "󰆴  Unmount" : "󰐚  Mount"
                                color: root.usbStatus === "mounted" ? "#ff6b6b" : "#b5e8b0"
                                font.pixelSize: 12
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle {
                                radius: 6
                                color: mountBtn.down ? Qt.rgba(1, 1, 1, 0.02) : Qt.rgba(1, 1, 1, 0.06)
                                border.color: root.usbStatus === "mounted" ? "#ff6b6b" : "#b5e8b0"
                                border.width: 1
                            }

                            onClicked: {
                                root.usbStatus = (root.usbStatus === "mounted") ? "unmounted" : "mounted"
                            }
                        }
                    }
                }
            }

            // ================= 2. Special Actions =================
            Column {
                width: parent.width
                spacing: 12
                opacity: root.usbStatus === "mounted" ? 1.0 : 0.5
                enabled: root.usbStatus === "mounted"

                Text {
                    text: "󰘳  Special Actions"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Row {
                    width: parent.width
                    spacing: 12

                    Rectangle {
                        id: formatBtn
                        width: (parent.width - 12) / 2
                        height: 50
                        radius: 10
                        color: formatMouse.containsMouse ? Qt.rgba(1, 0.4, 0.4, 0.1) : Qt.rgba(1, 1, 1, 0.02)
                        border.color: formatMouse.containsMouse ? "#ff6b6b" : Qt.rgba(1, 1, 1, 0.05)
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: 8
                            Text { text: "󰓡"; color: "#ff6b6b"; font.pixelSize: 16 }
                            Text { text: root.isFormatting ? "Formatting..." : "Quick Format (FAT32)"; color: "white"; font.pixelSize: 12; font.bold: true }
                        }

                        MouseArea {
                            id: formatMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                root.isFormatting = true
                                formatTimer.restart()
                            }
                        }
                    }

                    Rectangle {
                        id: flashBtn
                        width: (parent.width - 12) / 2
                        height: 50
                        radius: 10
                        color: flashMouse.containsMouse ? Qt.rgba(0.71, 0.91, 0.69, 0.1) : Qt.rgba(1, 1, 1, 0.02)
                        border.color: flashMouse.containsMouse ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.05)
                        border.width: 1

                        Row {
                            anchors.centerIn: parent
                            spacing: 8
                            Text { text: "󰚰"; color: "#b5e8b0"; font.pixelSize: 16 }
                            Text { text: "Flash Bootable ISO"; color: "white"; font.pixelSize: 12; font.bold: true }
                        }

                        MouseArea {
                            id: flashMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: console.log("Opening ISO selector...")
                        }
                    }
                }
            }

            // ================= 🌟 3. VENTOY BOOTABLE CREATOR (MỚI THÊM) =================
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "󰐚  Ventoy Bootable Flasher"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: 120
                    radius: 12
                    color: Qt.rgba(1, 1, 1, 0.03)
                    border.color: Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Item {
                        anchors.fill: parent
                        anchors.margins: 16

                        Column {
                            width: parent.width - 120
                            spacing: 6
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "Transform USB to Multi-Boot Drive"
                                color: "white"
                                font.pixelSize: 13
                                font.bold: true
                            }
                            Text {
                                text: "Install Ventoy into this drive. After installation, you can directly copy any Linux ISO files into the USB partition to boot them dynamically."
                                color: Qt.rgba(1, 1, 1, 0.4)
                                font.pixelSize: 11
                                wrapMode: Text.Wrap
                                width: parent.width
                            }
                        }

                        // Nút kích hoạt cài đặt Ventoy
                        Rectangle {
                            id: ventoyBtn
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 110
                            height: 38
                            radius: 8
                            color: root.isInstallingVentoy ? "transparent" : (ventoyMouse.containsMouse ? Qt.rgba(0.71, 0.91, 0.69, 0.15) : Qt.rgba(1, 1, 1, 0.04))
                            border.color: root.isInstallingVentoy ? Qt.rgba(1,1,1,0.1) : "#b5e8b0"
                            border.width: 1
                            enabled: !root.isInstallingVentoy

                            Text {
                                anchors.centerIn: parent
                                text: root.isInstallingVentoy ? "Installing..." : "󰐚  Install Ventoy"
                                color: root.isInstallingVentoy ? Qt.rgba(1,1,1,0.4) : "#b5e8b0"
                                font.pixelSize: 12
                                font.bold: true
                            }

                            MouseArea {
                                id: ventoyMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    root.isInstallingVentoy = true
                                    root.ventoyProgress = 0.0
                                    ventoyProgressTimer.restart()
                                }
                            }
                        }

                        // 🌟 Thanh Progress Bar kính mờ hiển thị tiến trình cài đặt thực tế
                        Rectangle {
                            id: progressTrack
                            width: parent.width
                            height: 4
                            radius: 2
                            color: Qt.rgba(1, 1, 1, 0.1)
                            anchors.bottom: parent.bottom
                            visible: root.isInstallingVentoy

                            Rectangle {
                                width: parent.width * root.ventoyProgress
                                height: parent.height
                                radius: 2
                                color: "#b5e8b0"

                                // Hiệu ứng làm mượt thanh chạy
                                Behavior on width { NumberAnimation { duration: 100 } }
                            }
                        }
                    }
                }
            }
        }
    }

    // Timer cho nút Format
    Timer { id: formatTimer; interval: 2000; onTriggered: { root.isFormatting = false; root.usbStatus = "unmounted"; } }

    // 🌟 Timer giả lập tiến độ chạy của phần trăm cài đặt Ventoy
    Timer {
        id: ventoyProgressTimer
        interval: 150
        repeat: true
        onTriggered: {
            if (root.ventoyProgress < 1.0) {
                root.ventoyProgress += 0.05
            } else {
                ventoyProgressTimer.stop()
                root.isInstallingVentoy = false
                console.log("Ventoy successfully installed on /dev/sdb!")
            }
        }
    }
}