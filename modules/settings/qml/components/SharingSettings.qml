import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    // Các biến quản lý cấu hình tên máy và mạng
    property string hostname: "Polaris-Machine"
    property string localIp: "192.168.1.15" // IP giả lập, sau này dùng C++ bốc thực tế
    property bool sshEnabled: false
    property int sshPort: 22

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
                text: "Sharing & Identity"
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            // ================= 1. NETWORK IDENTITY (ĐỔI TÊN MÁY HOSTNAME) =================
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "󰘚  Device Identity"
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

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Item {
                            width: parent.width
                            height: 36

                            Text {
                                text: "Device Name (Hostname)"
                                color: "white"
                                font.pixelSize: 13
                                font.bold: true
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            // Ô nhập liệu đổi tên máy cực chất
                            Rectangle {
                                width: 220
                                height: 32
                                radius: 6
                                color: Qt.rgba(1, 1, 1, 0.05)
                                border.color: hostInput.activeFocus ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.1)
                                border.width: 1
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter

                                TextInput {
                                    id: hostInput
                                    anchors.fill: parent
                                    anchors.leftMargin: 10
                                    anchors.rightMargin: 10
                                    verticalAlignment: TextInput.AlignVCenter
                                    text: root.hostname
                                    color: "white"
                                    font.pixelSize: 12
                                    font.family: "JetBrainsMono Nerd Font"
                                    selectByMouse: true

                                    onAccepted: {
                                        root.hostname = text
                                        console.log("Hostname changed to: " + text)
                                    }
                                }
                            }
                        }

                        Rectangle { width: parent.width; height: 1; color: Qt.rgba(1, 1, 1, 0.05) }

                        // Hiển thị IP để người dùng biết đường kết nối
                        Item {
                            width: parent.width; height: 20
                            Text { text: "Local IPv4 Address"; color: Qt.rgba(1, 1, 1, 0.5); font.pixelSize: 12; anchors.left: parent.left }
                            Text { text: root.localIp; color: "#b5e8b0"; font.pixelSize: 12; font.bold: true; font.family: "JetBrainsMono Nerd Font"; anchors.right: parent.right }
                        }
                    }
                }
            }

            // ================= 2. REMOTE ACCESS (CẤU HÌNH SSH SERVER) =================
            Column {
                width: parent.width
                spacing: 10

                Text {
                    text: "󰢹  Remote Access"
                    color: Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 12
                    font.bold: true
                }

                Rectangle {
                    width: parent.width
                    height: root.sshEnabled ? 160 : 70 // Co giãn mượt mà khi bật/tắt
                    radius: 12
                    color: Qt.rgba(1, 1, 1, 0.03)
                    border.color: root.sshEnabled ? Qt.rgba(0.71, 0.91, 0.69, 0.2) : Qt.rgba(1, 1, 1, 0.05)
                    border.width: 1

                    Behavior on height { NumberAnimation { duration: 200 } }

                    Column {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 14

                        // Công tắc bật tắt SSH tổng
                        Item {
                            width: parent.width; height: 24

                            Column {
                                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; spacing: 2
                                Text { text: "Secure Shell (SSH Server)"; color: "white"; font.pixelSize: 13; font.bold: true }
                                Text { text: "Allows terminal control and file transfer from remote clients"; color: Qt.rgba(1, 1, 1, 0.4); font.pixelSize: 11 }
                            }

                            Rectangle {
                                id: sshSwitch
                                width: 40; height: 22; radius: 11
                                color: root.sshEnabled ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.15)
                                anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter

                                Rectangle {
                                    width: 16; height: 16; radius: 8; color: "white"
                                    anchors.verticalCenter: parent.verticalCenter
                                    x: root.sshEnabled ? 21 : 3
                                    Behavior on x { NumberAnimation { duration: 150 } }
                                }
                                MouseArea { anchors.fill: parent; onClicked: root.sshEnabled = !root.sshEnabled }
                            }
                        }

                        // Phần hiển thị chi tiết khi SSH được bật
                        Column {
                            width: parent.width
                            spacing: 12
                            visible: root.sshEnabled
                            opacity: root.sshEnabled ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 200 } }

                            Rectangle { width: parent.width; height: 1; color: Qt.rgba(1, 1, 1, 0.05) }

                            // Port cấu hình
                            Item {
                                width: parent.width; height: 20
                                Text { text: "SSH Port Connection"; color: Qt.rgba(1, 1, 1, 0.6); font.pixelSize: 12; anchors.left: parent.left }
                                Text { text: root.sshPort.toString(); color: "white"; font.pixelSize: 12; font.family: "JetBrainsMono Nerd Font"; anchors.right: parent.right }
                            }

                            // Dòng lệnh mẫu để người dùng copy khi cần kết nối
                            Rectangle {
                                width: parent.width
                                height: 38
                                radius: 6
                                color: Qt.rgba(0, 0, 0, 0.2)
                                border.color: Qt.rgba(1, 1, 1, 0.05)
                                border.width: 1

                                Text {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 12
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: "󰖟  ssh nguyen@" + root.localIp + " -p " + root.sshPort
                                    color: "#b5e8b0"
                                    font.pixelSize: 12
                                    font.family: "JetBrainsMono Nerd Font"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}