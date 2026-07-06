import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    property bool globalSandbox: true
    property string newFilePath: ""

    // Biến tạm để lưu dữ liệu nhập vào Popup thêm App
    property string tempAppName: ""
    property string tempAppIcon: "󰀻"

    // 🌟 SỬ DỤNG LISTMODEL ĐỂ NGƯỜI DÙNG CÓ THỂ THÊM APP
    ListModel {
        id: appModel
        ListElement { name: "Google Chrome"; icon: "󰖟"; isSandboxed: true; desc: "Isolate session when browsing untrusted websites" }
        ListElement { name: "Discord Client"; icon: "󰙯"; isSandboxed: false; desc: "Prevent untrusted link/file token hijacking" }
        ListElement { name: "Deluge Torrent"; icon: "󰇚"; isSandboxed: true; desc: "Contain downloaded p2p files automatically" }
    }

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
                text: "Application & File Isolation (Sandbox)"
                color: "white"
                font.pixelSize: 22
                font.bold: true
            }

            // ================= 1. GLOBAL SWITCH =================
            Rectangle {
                width: parent.width; height: 70; radius: 12
                color: root.globalSandbox ? Qt.rgba(0.71, 0.91, 0.69, 0.06) : Qt.rgba(1, 1, 1, 0.03)
                border.color: root.globalSandbox ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.05); border.width: 1

                Item {
                    anchors.fill: parent; anchors.margins: 16
                    Column {
                        anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; spacing: 4
                        Text { text: "Enable Isolation Engine"; color: "white"; font.pixelSize: 13; font.bold: true }
                        Text { text: "Activate containment sub-system to isolate custom apps and untrusted binaries"; color: Qt.rgba(1, 1, 1, 0.4); font.pixelSize: 11 }
                    }
                    Rectangle {
                        width: 40; height: 22; radius: 11
                        color: root.globalSandbox ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.15)
                        anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                        Rectangle { width: 16; height: 16; radius: 8; color: "white"; anchors.verticalCenter: parent.verticalCenter; x: root.globalSandbox ? 21 : 3; Behavior on x { NumberAnimation { duration: 150 } } }
                        MouseArea { anchors.fill: parent; onClicked: root.globalSandbox = !root.globalSandbox }
                    }
                }
            }

            // Cụm cấu hình dưới chỉ sáng khi Engine tổng bật
            Column {
                width: parent.width; spacing: 24
                opacity: root.globalSandbox ? 1.0 : 0.3; enabled: root.globalSandbox
                Behavior on opacity { NumberAnimation { duration: 150 } }

                // ================= 2. DESIGNATED APPLICATIONS =================
                Column {
                    width: parent.width; spacing: 10

                    Item {
                        width: parent.width; height: 24
                        Text { text: "󰘳  Designated Applications"; color: Qt.rgba(1, 1, 1, 0.6); font.pixelSize: 12; font.bold: true; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter }

                        // 🌟 NÚT THÊM APP
                        Rectangle {
                            width: 130; height: 24; radius: 6
                            color: Qt.rgba(0.71, 0.91, 0.69, 0.1); border.color: "#b5e8b0"; border.width: 1
                            anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter
                            Text { text: "󰐕  Add Application"; color: "#b5e8b0"; font.pixelSize: 11; font.bold: true; anchors.centerIn: parent }
                            MouseArea { anchors.fill: parent; onClicked: addAppPopup.open() }
                        }
                    }

                    Column {
                        width: parent.width; spacing: 8

                        Repeater {
                            model: appModel
                            delegate: Rectangle {
                                width: parent.width; height: 55; radius: 10
                                color: Qt.rgba(1, 1, 1, 0.02); border.color: Qt.rgba(1, 1, 1, 0.05); border.width: 1

                                Item {
                                    anchors.fill: parent; anchors.margins: 12
                                    Text { id: appIcon; text: model.icon; color: "#b5e8b0"; font.pixelSize: 18; anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter }

                                    Column {
                                        anchors.left: appIcon.right; anchors.leftMargin: 12; anchors.verticalCenter: parent.verticalCenter; spacing: 2
                                        Text { text: model.name; color: "white"; font.pixelSize: 13; font.bold: true }
                                        Text { text: model.desc; color: Qt.rgba(1,1,1,0.3); font.pixelSize: 10 }
                                    }

                                    Row {
                                        anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; spacing: 12

                                        // Công tắc bật tắt sandbox riêng từng app
                                        Rectangle {
                                            id: appSwitch
                                            width: 36; height: 18; radius: 9
                                            color: model.isSandboxed ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.1)
                                            Rectangle { width: 14; height: 14; radius: 7; color: "white"; anchors.verticalCenter: parent.verticalCenter; x: model.isSandboxed ? 19 : 2; Behavior on x { NumberAnimation { duration: 120 } } }
                                            MouseArea { anchors.fill: parent; onClicked: model.isSandboxed = !model.isSandboxed }
                                        }

                                        // Nút xóa hẳn app khỏi danh sách sandbox
                                        Text {
                                            text: "󰅖"
                                            color: Qt.rgba(1,0,0,0.4)
                                            font.pixelSize: 14
                                            visible: model.name !== "Google Chrome" // Không cho xóa app mặc định để test
                                            MouseArea { anchors.fill: parent; onClicked: appModel.remove(index) }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // ================= 3. UNTRUSTED BINARIES =================
                Column {
                    width: parent.width; spacing: 10
                    Text { text: "󰚝  Untrusted Executables & Paths"; color: Qt.rgba(1, 1, 1, 0.6); font.pixelSize: 12; font.bold: true }

                    Column {
                        width: parent.width; spacing: 8
                        Row {
                            width: parent.width; spacing: 10
                            Rectangle {
                                width: parent.width - 120; height: 36; radius: 8
                                color: Qt.rgba(1,1,1,0.05); border.color: fileInput.activeFocus ? "#b5e8b0" : Qt.rgba(1,1,1,0.1); border.width: 1
                                TextInput {
                                    id: fileInput; anchors.fill: parent; anchors.margins: 10; verticalAlignment: TextInput.AlignVCenter
                                    text: root.newFilePath; color: "white"; font.pixelSize: 11; font.family: "JetBrainsMono Nerd Font"
                                    selectByMouse: true
                                }
                            }
                            Rectangle {
                                width: 110; height: 36; radius: 8
                                color: Qt.rgba(0.71, 0.91, 0.69, 0.15); border.color: "#b5e8b0"; border.width: 1
                                Text { text: "󰐕  Add Binary"; color: "#b5e8b0"; font.pixelSize: 12; font.bold: true; anchors.centerIn: parent }
                                MouseArea { anchors.fill: parent; onClicked: { if (fileInput.text !== "") { fileInput.text = ""; } } }
                            }
                        }
                    }
                }
            }
        }
    }

    // ================= 🌟 POPUP THÊM APP MỚI SIÊU ẢO DIỆU =================
    Popup {
        id: addAppPopup
        anchors.centerIn: parent
        width: 320; height: 180; modal: true; focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        background: Rectangle {
            color: "#1e1e2e"; radius: 12; border.color: Qt.rgba(1,1,1,0.1); border.width: 1
        }

        Column {
            anchors.fill: parent; anchors.margins: 16; spacing: 14

            Text { text: "Add Application to Sandbox"; color: "white"; font.pixelSize: 14; font.bold: true }

            // Ô nhập tên App
            Rectangle {
                width: parent.width; height: 36; radius: 6; color: Qt.rgba(1,1,1,0.05)
                border.color: nameInput.activeFocus ? "#b5e8b0" : Qt.rgba(1,1,1,0.1)
                TextField {
                    id: nameInput; anchors.fill: parent; anchors.margins: 10; verticalAlignment: TextInput.AlignVCenter
                    color: "white"; font.pixelSize: 12
                    placeholderText: "Enter process name (e.g., spotify)"
                    onTextChanged: root.tempAppName = text
                }
            }

            // Ô nhập ký tự Icon Nerd Font
            Rectangle {
                width: parent.width; height: 36; radius: 6; color: Qt.rgba(1,1,1,0.05)
                border.color: iconInput.activeFocus ? "#b5e8b0" : Qt.rgba(1,1,1,0.1)
                TextInput {
                    id: iconInput; anchors.fill: parent; anchors.margins: 10; verticalAlignment: TextInput.AlignVCenter
                    color: "white"; font.pixelSize: 12; text: root.tempAppIcon
                    onTextChanged: root.tempAppIcon = text
                }
            }

            Row {
                width: parent.width; spacing: 10; layoutDirection: Qt.RightToLeft

                // Nút Save
                Rectangle {
                    width: 70; height: 28; radius: 6; color: "#b5e8b0"
                    Text { text: "Save"; color: "#1e1e2e"; font.pixelSize: 12; font.bold: true; anchors.centerIn: parent }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (root.tempAppName !== "") {
                                // Nạp thẳng app mới vào ListModel cực kỳ mượt mà
                                appModel.append({
                                    name: root.tempAppName,
                                    icon: root.tempAppIcon,
                                    isSandboxed: true,
                                    desc: "Custom user-defined sandboxed application"
                                });
                                nameInput.text = "";
                                addAppPopup.close();
                            }
                        }
                    }
                }

                // Nút Cancel
                Rectangle {
                    width: 70; height: 28; radius: 6; color: Qt.rgba(1,1,1,0.1)
                    Text { text: "Cancel"; color: "white"; font.pixelSize: 12; anchors.centerIn: parent }
                    MouseArea { anchors.fill: parent; onClicked: addAppPopup.close() }
                }
            }
        }
    }
}