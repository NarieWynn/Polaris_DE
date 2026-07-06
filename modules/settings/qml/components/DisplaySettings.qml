import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    // 🌟 FIX LỖI 2: Check chuẩn chỉ cả null và undefined để chạy chay đéo bao giờ báo lỗi bậy
    property int currentBrightness: (typeof sysHardware !== "undefined" && sysHardware !== null) ? sysHardware.brightness : 80
    property bool nightLightActive: false
    property int nightLightTemp: 4500

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
                text: "Display"
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            // ================= 1. BRIGHTNESS =================
            Column {
                width: parent.width
                spacing: 12

                Row {
                    width: parent.width
                    spacing: 8

                    Text {
                        text: "󰃠  Brightness"
                        color: "white"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }
                    Text {
                        text: root.currentBrightness + "%"
                        color: "#b5e8b0"
                        font.pixelSize: 14
                        font.bold: true
                    }
                }

                Slider {
                    id: brightnessSlider
                    width: parent.width
                    to: 100
                    value: root.currentBrightness
                    stepSize: 1

                    onMoved: {
                        root.currentBrightness = value
                        if (typeof sysHardware !== "undefined" && sysHardware !== null) {
                            sysHardware.brightness = value
                        }
                    }

                    background: Rectangle {
                        x: brightnessSlider.leftPadding
                        y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 6
                        width: brightnessSlider.availableWidth
                        height: implicitHeight
                        radius: 3
                        color: Qt.rgba(1, 1, 1, 0.1)

                        Rectangle {
                            width: brightnessSlider.visualPosition * parent.width
                            height: parent.height
                            color: "#b5e8b0"
                            radius: 3
                        }
                    }

                    handle: Rectangle {
                        x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
                        y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        color: "white"
                        border.color: "#b5e8b0"
                        border.width: 2
                    }
                }
            }

            // ================= 2. RESOLUTION & REFRESH RATE =================
            Column {
                width: parent.width
                spacing: 14

                Text {
                    text: "󰍹  Monitor Configuration"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Row {
                    width: parent.width
                    spacing: 16

                    Column {
                        width: (parent.width - 16) / 2
                        spacing: 6
                        Text { text: "Resolution"; color: "white"; font.pixelSize: 12; opacity: 0.8 }

                        Rectangle {
                            width: parent.width; height: 42; radius: 8
                            color: Qt.rgba(1, 1, 1, 0.03); border.color: Qt.rgba(1, 1, 1, 0.05); border.width: 1
                            Text { text: "1920 x 1080 (16:9)"; color: "white"; font.pixelSize: 13; anchors.left: parent.left; anchors.leftMargin: 12; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: ""; color: "white"; font.pixelSize: 11; anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter }
                        }
                    }

                    Column {
                        width: (parent.width - 16) / 2
                        spacing: 6
                        Text { text: "Refresh Rate"; color: "white"; font.pixelSize: 12; opacity: 0.8 }

                        Rectangle {
                            width: parent.width; height: 42; radius: 8
                            color: Qt.rgba(1, 1, 1, 0.03); border.color: Qt.rgba(1, 1, 1, 0.05); border.width: 1
                            Text { text: "144.00 Hz"; color: "#b5e8b0"; font.pixelSize: 13; font.bold: true; anchors.left: parent.left; anchors.leftMargin: 12; anchors.verticalCenter: parent.verticalCenter }
                            Text { text: ""; color: "white"; font.pixelSize: 11; anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing: 6
                    Text { text: "Scale (HiDPI)"; color: "white"; font.pixelSize: 12; opacity: 0.8 }

                    Rectangle {
                        width: parent.width; height: 42; radius: 8
                        color: Qt.rgba(1, 1, 1, 0.03); border.color: Qt.rgba(1, 1, 1, 0.05); border.width: 1
                        Text { text: "100% (Default)"; color: "white"; font.pixelSize: 13; anchors.left: parent.left; anchors.leftMargin: 12; anchors.verticalCenter: parent.verticalCenter }
                        Text { text: ""; color: "white"; font.pixelSize: 11; anchors.right: parent.right; anchors.rightMargin: 12; anchors.verticalCenter: parent.verticalCenter }
                    }
                }
            }

            // ================= 3. NIGHT LIGHT =================
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "󰖔  Night Shift"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Rectangle {
                    id: nightLightBox
                    width: parent.width
                    height: root.nightLightActive ? 140 : 56
                    radius: 10
                    color: root.nightLightActive ? Qt.rgba(1, 0.67, 0.2, 0.06) : Qt.rgba(1, 1, 1, 0.03)
                    border.color: root.nightLightActive ? Qt.rgba(1, 0.67, 0.2, 0.2) : Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1
                    clip: true

                    Behavior on height { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }

                    Item {
                        id: headerToggleArea
                        width: parent.width
                        height: 56
                        anchors.top: parent.top

                        Item {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 4
                                Text { text: "Night Light"; color: "white"; font.pixelSize: 14; font.bold: true }
                                Text { text: "Reduce blue light to soothe the eyes at night"; color: Qt.rgba(1, 1, 1, 0.5); font.pixelSize: 11 }
                            }

                            Rectangle {
                                id: switchTrack
                                width: 40; height: 22; radius: 11
                                color: root.nightLightActive ? "#ff9f1c" : Qt.rgba(1, 1, 1, 0.15)
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter

                                Rectangle {
                                    id: switchHandle
                                    width: 16; height: 16; radius: 8; color: "white"
                                    anchors.verticalCenter: parent.verticalCenter
                                    x: root.nightLightActive ? 21 : 3

                                    Behavior on x { NumberAnimation { duration: 150 } }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: root.nightLightActive = !root.nightLightActive
                                }
                            }
                        }
                    }

                    // 🌟 FIX LỖI 1: Thay Column chứa Row rác bằng Item định vị Anchors chuẩn chỉ tuyệt đối
                    Item {
                        id: temperatureArea
                        anchors.top: headerToggleArea.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        height: 60

                        opacity: root.nightLightActive ? 1.0 : 0.0
                        visible: opacity > 0.0
                        Behavior on opacity { NumberAnimation { duration: 200 } }

                        // Chữ tiêu đề nằm bên trái
                        Text {
                            id: tempTitle
                            text: "Color Temperature"
                            color: "white"
                            font.pixelSize: 12
                            opacity: 0.8
                            anchors.top: parent.top
                            anchors.left: parent.left
                        }

                        // Số Kelvin neo cứng ở bên phải
                        Text {
                            text: root.nightLightTemp + " K"
                            color: "#ff9f1c"
                            font.pixelSize: 12
                            font.bold: true
                            anchors.top: parent.top
                            anchors.right: parent.right
                        }

                        Slider {
                            id: tempSlider
                            width: parent.width
                            anchors.top: tempTitle.bottom
                            anchors.topMargin: 8
                            from: 2500
                            to: 6500
                            value: 6500 - (root.nightLightTemp - 2500)
                            stepSize: 100

                            onMoved: {
                                root.nightLightTemp = 6500 - value + 2500
                            }

                            background: Rectangle {
                                x: tempSlider.leftPadding
                                y: tempSlider.topPadding + tempSlider.availableHeight / 2 - height / 2
                                width: tempSlider.availableWidth
                                height: 6
                                radius: 3
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "#FFFFFF" }
                                    GradientStop { position: 1.0; color: "#ff8c00" }
                                }
                            }

                            handle: Rectangle {
                                x: tempSlider.leftPadding + tempSlider.visualPosition * (tempSlider.availableWidth - width)
                                y: tempSlider.topPadding + tempSlider.availableHeight / 2 - height / 2
                                implicitWidth: 16
                                implicitHeight: 16
                                radius: 8
                                color: "white"
                                border.color: "#ff9f1c"
                                border.width: 2
                            }
                        }
                    }
                }
            }
        }
    }
}