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
            spacing: 28

            Text {
                text: "About"
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            // ================= LOGO POLARIS HOÀNH TRÁNG =================
            Column {
                width: parent.width
                spacing: 12
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: 80
                    height: 80
                    radius: 40
                    color: Qt.rgba(0.71, 0.91, 0.69, 0.1)
                    border.color: "#b5e8b0"
                    border.width: 2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "P"
                        color: "#b5e8b0"
                        font.pixelSize: 36
                        font.bold: true
                    }
                }

                Text {
                    text: "Polaris Desktop Environment"
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Version 1.0.0 (Wayland-based)"
                    color: Qt.rgba(1, 1, 1, 0.4)
                    font.pixelSize: 11
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            // ================= THÔNG TIN CẤU HÌNH HỆ THỐNG =================
            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "󰘚  System Information"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                // Hộp kính mờ bọc mớ thông tin
                Rectangle {
                    width: parent.width
                    height: 180
                    radius: 12
                    color: Qt.rgba(1, 1, 1, 0.03)
                    border.color: Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        // Dòng 1: OS
                        Item {
                            width: parent.width; height: 16
                            Text { text: "OS Name"; color: Qt.rgba(1, 1, 1, 0.6); font.pixelSize: 13; anchors.left: parent.left }
                            Text { text: "CachyOS"; color: "white"; font.pixelSize: 13; font.bold: true; anchors.right: parent.right }
                        }

                        // Khung chia nhẹ giữa các dòng
                        Rectangle { width: parent.width; height: 1; color: Qt.rgba(1, 1, 1, 0.05) }

                        // Dòng 2: Hardware Host
                        Item {
                            width: parent.width; height: 16
                            Text { text: "Hardware Model"; color: Qt.rgba(1, 1, 1, 0.6); font.pixelSize: 13; anchors.left: parent.left }
                            Text { text: "Lenovo LOQ Laptop"; color: "white"; font.pixelSize: 13; anchors.right: parent.right }
                        }

                        Rectangle { width: parent.width; height: 1; color: Qt.rgba(1, 1, 1, 0.05) }

                        // Dòng 3: Compositor
                        Item {
                            width: parent.width; height: 16
                            Text { text: "Window Manager"; color: Qt.rgba(1, 1, 1, 0.6); font.pixelSize: 13; anchors.left: parent.left }
                            Text { text: "Hyprland (Wayland)"; color: "#b5e8b0"; font.pixelSize: 13; anchors.right: parent.right }
                        }

                        Rectangle { width: parent.width; height: 1; color: Qt.rgba(1, 1, 1, 0.05) }

                        // Dòng 4: Kernel
                        Item {
                            width: parent.width; height: 16
                            Text { text: "Kernel Version"; color: Qt.rgba(1, 1, 1, 0.6); font.pixelSize: 13; anchors.left: parent.left }
                            Text { text: "6.x.x-arch1-1"; color: "white"; font.pixelSize: 13; anchors.right: parent.right }
                        }
                    }
                }
            }

            // ================= 🌟 CỤM QUẢN LÝ UPDATE ĐỘNG THÔNG MINH =================
            Column {
                width: parent.width
                spacing: 12

                // State quản lý trạng thái: "idle" (bình thường), "checking" (đang check), "available" (có hàng mới)
                property string updateState: "idle"

                Rectangle {
                    id: updateBtn
                    width: parent.width
                    height: 50
                    radius: 10
                    color: parent.updateState === "available" ? Qt.rgba(0.71, 0.91, 0.69, 0.1) :
                        btnMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.06) : Qt.rgba(1, 1, 1, 0.03)
                    border.color: parent.updateState === "available" ? "#b5e8b0" :
                        btnMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Item {
                        anchors.fill: parent
                        anchors.margins: 14

                        Row {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 12

                            // Icon trạng thái động
                            Text {
                                text: parent.parent.parent.updateState === "checking" ? "󰑐" : "󰚰"
                                color: parent.parent.parent.updateState === "available" ? "#b5e8b0" : "white"
                                font.pixelSize: 16
                                font.family: "JetBrainsMono Nerd Font"

                                // Hiệu ứng xoay vòng vòng liên tục khi đang check update
                                RotationAnimation on rotation {
                                    running: parent.parent.parent.parent.updateState === "checking"
                                    from: 0; to: 360; loops: Animation.Infinite; duration: 1000
                                }
                            }

                            Column {
                                spacing: 2
                                Text {
                                    text: parent.parent.parent.parent.updateState === "idle" ? "Check for System Updates" :
                                            parent.parent.parent.parent.updateState === "checking" ? "Checking repositories..." :
                                            "System Updates Available"
                                    color: "white"; font.pixelSize: 13; font.bold: true
                                }
                                Text {
                                    text: parent.parent.parent.parent.updateState === "idle" ? "Synchronize CachyOS core & Polaris DE modules" :
                                            parent.parent.parent.parent.updateState === "checking" ? "Fetching package databases from Arch mirrors" :
                                            "New updates for Hyprland core and Polaris components are ready"
                                    color: Qt.rgba(1, 1, 1, 0.4); font.pixelSize: 11
                                }
                            }
                        }

                        // Nút Download hiện ra bên phải KHI CÓ UPDATE MỚI
                        Rectangle {
                            visible: parent.parent.parent.updateState === "available"
                            width: 140; height: 28; radius: 6; color: "#b5e8b0"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "󰇚  Download & Install"
                                color: "#1e1e2e"; font.pixelSize: 11; font.bold: true
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    console.log("Backend C++ Triggered: sudo pacman -Syu --noconfirm");
                                    parent.parent.parent.parent.updateState = "idle"; // Reset về ban đầu sau khi bấm cài
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: btnMouse
                        anchors.fill: parent
                        // Vô hiệu hóa vùng click tổng khi đang check hoặc khi đã tìm thấy update
                        enabled: parent.parent.updateState === "idle"
                        hoverEnabled: true
                        onClicked: {
                            parent.parent.updateState = "checking";

                            // Giả lập sau 2.5 giây check mạng xong thì báo có Update mới
                            updateTimer.start();
                        }
                    }
                }

                // Bộ đếm thời gian giả lập phản hồi từ Backend mạng
                Timer {
                    id: updateTimer
                    interval: 2500; running: false; repeat: false
                    onTriggered: parent.updateState = "available"
                }
                // ================= 🌟 NÚT DONATE SUPPORT  =================
                Rectangle {
                    id: donateBtn
                    width: parent.width
                    height: 45
                    radius: 10
                    color: donateMouse.containsMouse ? Qt.rgba(0.71, 0.91, 0.69, 0.1) : Qt.rgba(1, 1, 1, 0.03)
                    border.color: donateMouse.containsMouse ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "󰡵  Support Polaris Development (Donate)"
                        color: donateMouse.containsMouse ? "#b5e8b0" : "white"
                        font.pixelSize: 13
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                    }

                    MouseArea {
                        id: donateMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: donatePopup.open() // Bấm mở Popup QR
                    }
                }

                // ================= 🎨 POPUP QR CODE  =================
                Popup {
                    id: donatePopup
                    anchors.centerIn: parent
                    width: 340; height: 380; modal: true; focus: true
                    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

                    background: Rectangle {
                        color: "#1e1e2e"; radius: 16; border.color: Qt.rgba(1,1,1,0.1); border.width: 1
                    }

                    Column {
                        anchors.fill: parent; anchors.margins: 20; spacing: 16

                        Text {
                            text: "Support Free Knowledge & Creation"; color: "#b5e8b0"
                            font.pixelSize: 14; font.bold: true; font.family: "JetBrainsMono Nerd Font"; anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Rectangle {
                            width: 200; height: 200; radius: 12; color: "white"
                            anchors.horizontalCenter: parent.horizontalCenter

                            Image {
                                anchors.fill: parent; anchors.margins: 8
                                source: "qrc:/qt/qml/polaris/assets/my_qr_code.png"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Text {
                            text: "If Polaris makes your Linux experience better, consider fueling the project. Every contribution inspires the pursuit of code and freedom."
                            color: Qt.rgba(1, 1, 1, 0.5); font.pixelSize: 11; horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.Wrap; width: parent.width; font.family: "JetBrainsMono Nerd Font"
                        }

                        Rectangle {
                            width: 80; height: 30; radius: 6; color: Qt.rgba(1,1,1,0.08)
                            anchors.horizontalCenter: parent.horizontalCenter
                            Text { text: "Close"; color: "white"; font.pixelSize: 12; anchors.centerIn: parent }
                            MouseArea { anchors.fill: parent; onClicked: donatePopup.close() }
                        }
                    }
                }
            }
        }
    }
}