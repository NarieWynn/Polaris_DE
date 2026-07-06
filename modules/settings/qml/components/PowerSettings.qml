import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    // Check an toàn biến sysBattery từ C++ truyền sang để tránh lỗi null lúc chạy chay
    property int batteryLevel: (typeof sysBattery !== "undefined" && sysBattery !== null) ? sysBattery.level : 80
    property bool isCharging: (typeof sysBattery !== "undefined" && sysBattery !== null) ? sysBattery.charging : false

    // Biến lưu chế độ năng lượng: "performance", "balanced", "powersave"
    property string currentProfile: "balanced"
    property int screenTimeout: 5 // số phút mặc định

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
                text: "Power Management"
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            // ================= 1. BATTERY STATUS (MOCKUP TRẠNG THÁI PIN) =================
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "󰁹  Battery Status"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: 70
                    radius: 12
                    color: Qt.rgba(1, 1, 1, 0.03)
                    border.color: Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Item {
                        anchors.fill: parent
                        anchors.margins: 16

                        // Biểu tượng cục pin động
                        Text {
                            id: batteryIcon
                            text: root.isCharging ? "󱐋" : (root.batteryLevel > 50 ? "󰁹" : "󰁺")
                            color: root.isCharging ? "#6bffb5" : (root.batteryLevel > 20 ? "#b5e8b0" : "#ff6b6b")
                            font.pixelSize: 28
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            anchors.left: batteryIcon.right
                            anchors.leftMargin: 16
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text: root.batteryLevel + "% Available"
                                color: "white"
                                font.pixelSize: 14
                                font.bold: true
                            }
                            Text {
                                text: root.isCharging ? "Charging style Polaris..." : "Discharging on battery"
                                color: Qt.rgba(1, 1, 1, 0.4)
                                font.pixelSize: 11
                            }
                        }
                    }
                }
            }

            // ================= 2. POWER PROFILES (CHỌN CHẾ ĐỘ HIỆU NĂNG) =================
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "󰓅  Power Profiles"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                // Hàng chứa 3 nút chọn chế độ hiệu năng
                Row {
                    width: parent.width
                    spacing: 12

                    // --- Nút 1: Power Saver ---
                    Rectangle {
                        width: (parent.width - 24) / 3
                        height: 90
                        radius: 10
                        color: root.currentProfile === "powersave" ? Qt.rgba(0.71, 0.91, 0.69, 0.1) : Qt.rgba(1, 1, 1, 0.02)
                        border.color: root.currentProfile === "powersave" ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.05)
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            Text { text: "󰾆"; color: root.currentProfile === "powersave" ? "#b5e8b0" : "white"; font.pixelSize: 20; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "Power Saver"; color: "white"; font.pixelSize: 13; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                        }

                        MouseArea { anchors.fill: parent; onClicked: root.currentProfile = "powersave" }
                    }

                    // --- Nút 2: Balanced ---
                    Rectangle {
                        width: (parent.width - 24) / 3
                        height: 90
                        radius: 10
                        color: root.currentProfile === "balanced" ? Qt.rgba(0.71, 0.91, 0.69, 0.1) : Qt.rgba(1, 1, 1, 0.02)
                        border.color: root.currentProfile === "balanced" ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.05)
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            Text { text: "󰗑"; color: root.currentProfile === "balanced" ? "#b5e8b0" : "white"; font.pixelSize: 20; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "Balanced"; color: "white"; font.pixelSize: 13; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                        }

                        MouseArea { anchors.fill: parent; onClicked: root.currentProfile = "balanced" }
                    }

                    // --- Nút 3: Performance ---
                    Rectangle {
                        width: (parent.width - 24) / 3
                        height: 90
                        radius: 10
                        color: root.currentProfile === "performance" ? Qt.rgba(1, 0.4, 0.4, 0.1) : Qt.rgba(1, 1, 1, 0.02)
                        border.color: root.currentProfile === "performance" ? "#ff6b6b" : Qt.rgba(1, 1, 1, 0.05)
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            Text { text: "󰓅"; color: root.currentProfile === "performance" ? "#ff6b6b" : "white"; font.pixelSize: 20; anchors.horizontalCenter: parent.horizontalCenter }
                            Text { text: "Performance"; color: "white"; font.pixelSize: 13; font.bold: true; anchors.horizontalCenter: parent.horizontalCenter }
                        }

                        MouseArea { anchors.fill: parent; onClicked: root.currentProfile = "performance" }
                    }
                }
            }

            // ================= 3. SCREEN TIMEOUT (TỰ ĐỘNG TẮT MÀN HÌNH) =================
            Column {
                width: parent.width
                spacing: 12

                Item {
                    width: parent.width
                    height: 20
                    Text { text: "󰛊  Turn off screen after"; color: Qt.rgba(1, 1, 1, 0.6); font.pixelSize: 12; font.bold: true; anchors.left: parent.left }
                    Text {
                        text: root.screenTimeout === 31 ? "Never" : root.screenTimeout + " minutes"
                        color: "#b5e8b0"
                        font.pixelSize: 12
                        font.bold: true
                        anchors.right: parent.right
                    }
                }

                Slider {
                    id: timeoutSlider
                    width: parent.width
                    from: 1
                    to: 31
                    stepSize: 5
                    value: root.screenTimeout

                    onMoved: {
                        root.screenTimeout = value
                        // Trực tiếp map backend sau này ở đây
                    }

                    background: Rectangle {
                        x: timeoutSlider.leftPadding
                        y: timeoutSlider.topPadding + timeoutSlider.availableHeight / 2 - height / 2
                        width: timeoutSlider.availableWidth
                        height: 6
                        radius: 3
                        color: Qt.rgba(1, 1, 1, 0.1)

                        Rectangle {
                            width: timeoutSlider.visualPosition * parent.width
                            height: parent.height
                            color: "#b5e8b0"
                            radius: 3
                        }
                    }

                    handle: Rectangle {
                        x: timeoutSlider.leftPadding + timeoutSlider.visualPosition * (timeoutSlider.availableWidth - width)
                        y: timeoutSlider.topPadding + timeoutSlider.availableHeight / 2 - height / 2
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
    }
}