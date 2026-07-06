import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    // Các biến quản lý cấu hình tường lửa
    property bool firewallEnabled: false
    property string securityProfile: "public" // "home" hoặc "public"

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
                text: "Firewall & Security"
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            // ================= 1. FIREWALL TOGGLE (CÔNG TẮC TỔNG) =================
            Rectangle {
                width: parent.width
                height: 70
                radius: 12
                color: root.firewallEnabled ? Qt.rgba(0.71, 0.91, 0.69, 0.06) : Qt.rgba(1, 1, 1, 0.03)
                border.color: root.firewallEnabled ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.05)
                border.width: 1

                Item {
                    anchors.fill: parent
                    anchors.margins: 16

                    Column {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4
                        Text { text: "Enable System Firewall"; color: "white"; font.pixelSize: 13; font.bold: true }
                        Text { text: "Protect your device from unauthorized remote network access"; color: Qt.rgba(1, 1, 1, 0.4); font.pixelSize: 11 }
                    }

                    Rectangle {
                        id: fwSwitch
                        width: 40; height: 22; radius: 11
                        color: root.firewallEnabled ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.15)
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        Rectangle {
                            width: 16; height: 16; radius: 8; color: "white"
                            anchors.verticalCenter: parent.verticalCenter
                            x: root.firewallEnabled ? 21 : 3
                            Behavior on x { NumberAnimation { duration: 150 } }
                        }
                        MouseArea { anchors.fill: parent; onClicked: root.firewallEnabled = !root.firewallEnabled }
                    }
                }
            }

            // ================= 2. SECURITY PROFILES (CHẾ ĐỘ BẢO MẬT) =================
            Column {
                width: parent.width
                spacing: 12
                opacity: root.firewallEnabled ? 1.0 : 0.4
                enabled: root.firewallEnabled
                Behavior on opacity { NumberAnimation { duration: 150 } }

                Text {
                    text: "󰒋  Security Profiles"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Row {
                    width: parent.width
                    spacing: 12

                    // --- Chế độ Trusted (Home/Lab) ---
                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 90
                        radius: 10
                        color: root.securityProfile === "home" ? Qt.rgba(0.71, 0.91, 0.69, 0.1) : Qt.rgba(1, 1, 1, 0.02)
                        border.color: root.securityProfile === "home" ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.05)
                        border.width: 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 6
                            Text { text: "󱂚  Home / Trusted Network"; color: "white"; font.pixelSize: 13; font.bold: true }
                            Text { text: "Allows internal connections like local SSH and local file sharing."; color: Qt.rgba(1,1,1,0.4); font.pixelSize: 11; wrapMode: Text.Wrap; width: parent.width }
                        }
                        MouseArea { anchors.fill: parent; onClicked: root.securityProfile = "home" }
                    }

                    // --- Chế độ Untrusted (Cafe/School Wi-Fi) ---
                    Rectangle {
                        width: (parent.width - 12) / 2
                        height: 90
                        radius: 10
                        color: root.securityProfile === "public" ? Qt.rgba(1, 0.4, 0.4, 0.1) : Qt.rgba(1, 1, 1, 0.02)
                        border.color: root.securityProfile === "public" ? "#ff6b6b" : Qt.rgba(1, 1, 1, 0.05)
                        border.width: 1

                        Column {
                            anchors.fill: parent
                            anchors.margins: 14
                            spacing: 6
                            Text { text: "󰶾  Public / Untrusted Network"; color: "white"; font.pixelSize: 13; font.bold: true }
                            Text { text: "Strict mode. Blocks all incoming connection requests completely."; color: Qt.rgba(1,1,1,0.4); font.pixelSize: 11; wrapMode: Text.Wrap; width: parent.width }
                        }
                        MouseArea { anchors.fill: parent; onClicked: root.securityProfile = "public" }
                    }
                }
            }
        }
    }
}