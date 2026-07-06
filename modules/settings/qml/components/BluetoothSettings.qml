import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    property bool bluetoothEnabled: false
    property bool isScanning: false

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
                text: "Bluetooth"
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            // ================= 1. CÔNG TẮC BẬT/TẮT TỔNG =================
            Rectangle {
                width: parent.width
                height: 56
                radius: 10
                color: root.bluetoothEnabled ? Qt.rgba(0.71, 0.91, 0.69, 0.06) : Qt.rgba(1, 1, 1, 0.03)
                border.color: root.bluetoothEnabled ? Qt.rgba(0.71, 0.91, 0.69, 0.2) : Qt.rgba(1, 1, 1, 0.05)
                border.width: 1

                Item {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16

                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 12
                        Text { text: "󰂯"; color: root.bluetoothEnabled ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.4); font.pixelSize: 20 }
                        Text { text: "Bluetooth"; color: "white"; font.pixelSize: 14; font.bold: true }
                    }

                    Rectangle {
                        id: switchTrack
                        width: 40; height: 22; radius: 11
                        color: root.bluetoothEnabled ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.15)
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            id: switchHandle
                            width: 16; height: 16; radius: 8; color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.bluetoothEnabled ? 21 : 3
                            Behavior on x { NumberAnimation { duration: 150 } }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                root.bluetoothEnabled = !root.bluetoothEnabled
                                if (!root.bluetoothEnabled) root.isScanning = false
                            }
                        }
                    }
                }
            }

            // ================= 2. KHU VỰC THIẾT BỊ (CHỈ HIỆN KHI BẬT) =================
            Column {
                width: parent.width
                spacing: 16
                opacity: root.bluetoothEnabled ? 1.0 : 0.0
                visible: opacity > 0.0
                Behavior on opacity { NumberAnimation { duration: 200 } }

                // Thanh tiêu đề + Nút Quét thiết bị
                Item {
                    width: parent.width
                    height: 24

                    Text {
                        text: "Available Devices"
                        color: Qt.rgba(1, 1, 1, 0.6)
                        font.pixelSize: 12
                        font.bold: true
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Nút bấm Scan làm màu quay quay kìa mài
                    Row {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 6
                        visible: root.bluetoothEnabled

                        // Icon xoay tròn giả lập tiến trình scan
                        Text {
                            text: "󰑐"
                            color: "#b5e8b0"
                            font.pixelSize: 13
                            visible: root.isScanning

                            RotationAnimator on rotation {
                                loops: Animation.Infinite
                                from: 0
                                to: 360
                                duration: 1000
                                running: root.isScanning
                            }
                        }

                        Text {
                            text: root.isScanning ? "Scanning..." : "󰂰  Scan"
                            color: "#b5e8b0"
                            font.pixelSize: 12
                            font.bold: true

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (root.bluetoothEnabled) {
                                        root.isScanning = true
                                        // Giả lập quét 3 giây rồi tắt
                                        scanTimer.restart()
                                    }
                                }
                            }
                        }
                    }
                }

                // Danh sách thiết bị kết nối (Mockup giả lập sẵn)
                Column {
                    width: parent.width
                    spacing: 8

                    // Thiết bị 1: Tai nghe (Đã kết nối)
                    Rectangle {
                        width: parent.width; height: 50; radius: 10
                        color: Qt.rgba(1, 1, 1, 0.02); border.color: Qt.rgba(1, 1, 1, 0.04); border.width: 1
                        Item {
                            anchors.fill: parent; anchors.margins: 14
                            Text { id: icon1; text: "󰋋"; color: "#b5e8b0"; font.pixelSize: 16; anchors.verticalCenter: parent.verticalCenter }
                            Column {
                                anchors.left: icon1.right; anchors.leftMargin: 12; anchors.verticalCenter: parent.verticalCenter
                                Text { text: "Sony WH-1000XM4"; color: "white"; font.pixelSize: 13; font.bold: true }
                                Text { text: "Connected"; color: "#b5e8b0"; font.pixelSize: 10 }
                            }
                            Text { text: "󰓅"; color: Qt.rgba(1, 1, 1, 0.3); font.pixelSize: 14; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                        }
                    }

                    // Thiết bị 2: Chuột không dây
                    Rectangle {
                        width: parent.width; height: 50; radius: 10
                        color: Qt.rgba(1, 1, 1, 0.02)
                        Item {
                            anchors.fill: parent; anchors.margins: 14
                            Text { id: icon2; text: "󰍽"; color: "white"; font.pixelSize: 16; anchors.verticalCenter: parent.verticalCenter; opacity: 0.6 }
                            Text { text: "Logitech MX Master 3S"; color: "white"; font.pixelSize: 13; anchors.left: icon2.right; anchors.leftMargin: 12; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: "Paired"; color: Qt.rgba(1, 1, 1, 0.4); font.pixelSize: 12; anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter }
                        }
                    }
                }
            }
        }
    }

    // Bộ đếm thời gian giả lập trạng thái quét thiết bị
    Timer {
        id: scanTimer
        interval: 3000
        onTriggered: root.isScanning = false
    }
}