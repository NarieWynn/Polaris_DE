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
            id: mainDivider
            anchors.top: titleBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Qt.rgba(0.71, 0.91, 0.69, 0.15)
        }

        Row {
            anchors.top: mainDivider.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            // Sidebar Container
            Rectangle {
                width: parent.width * 0.28
                height: parent.height
                color: Qt.rgba(0, 0, 0, 0.3)

                // 🌟 SỬ DỤNG FLICKABLE ĐỂ CHO PHÉP CUỘN DANH SÁCH TAB
                Flickable {
                    id: sidebarScroll
                    anchors.fill: parent
                    anchors.margins: 10
                    contentHeight: sidebarColumn.height
                    clip: true

                    // Ép vùng cuộn trả về khi kéo quá đà (bouncing effect) cho mượt
                    boundsBehavior: Flickable.StopAtBounds

                    // 🌟 CÚ PHÁP CHUẨN ĐỂ ĐÍNH KÈM THANH CUỘN TRONG QT6:
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        active: sidebarScroll.moving || sidebarScroll.flicking
                    }

                    Column {
                        id: sidebarColumn
                        width: parent.width
                        spacing: 4

                        Repeater {
                            model: [
                                { id: "wifi",      label: "󰖩  Wi-Fi" },
                                { id: "bluetooth", label: "󰂯  Bluetooth" },
                                { id: "sound",     label: "󰕾  Sound" },
                                { id: "display",   label: "󰍹  Display" },
                                { id: "sharing",   label: "󰘖  Sharing" },
                                { id: "security",  label: "󰒋  Security" },
                                { id: "sandbox",   label: "󰏖  Sandbox" },
                                { id: "usb",       label: "󱊞  USB & Disks" },
                                { id: "power",     label: "󰓅  Power" },
                                { id: "shortcuts", label: "󰌌  Shortcuts" },
                                { id: "about",     label: "󰘚  About" }
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
                                    color: currentTab === modelData.id ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.6)
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
            }

            // Right Content Area
            Rectangle {
                width: parent.width * 0.72
                height: parent.height
                color: "transparent"

                Loader {
                    anchors.fill: parent
                    anchors.margins: 20

                    source: currentTab === "wifi" ? "components/WifiSettings.qml" :
                            currentTab === "bluetooth" ? "components/BluetoothSettings.qml" :
                                currentTab === "sound" ? "components/SoundSettings.qml" :
                                    currentTab === "display" ? "components/DisplaySettings.qml" :
                                        currentTab === "sharing" ? "components/SharingSettings.qml" :
                                            currentTab === "security" ? "components/FirewallSettings.qml" :
                                                currentTab === "sandbox" ? "components/SandboxSettings.qml" :
                                                    currentTab === "usb" ? "components/UsbSettings.qml" :
                                                        currentTab === "power" ? "components/PowerSettings.qml" :
                                                            currentTab === "shortcuts" ? "components/ShortcutsSettings.qml" :
                                                                currentTab === "about" ? "components/AboutSettings.qml" : ""
                                                                    //"components/ComingSoon.qml"
                }
            }
        }
    }
}