import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    // Biến tạm để mày binding test logic
    property string pendingSsid: ""
    property bool showPassword: false

    Component.onCompleted: {
        if (typeof sysWifi !== "undefined") sysWifi.scan()
    }

    // --- TẦNG TIÊU ĐỀ & CÔNG TẮC TỔNG ---
    Row {
        id: headerRow
        width: parent.width
        height: 40
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Text {
            text: "Wi-Fi"
            color: "#FFFFFF"
            font.pixelSize: 22
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }

        // Mày có thể nhét thêm cái Switch bật/tắt tổng ở đây nếu muốn nâng cấp
    }

    // --- DANH SÁCH MẠNG WI-FI ---
    ListView {
        id: wifiListView
        anchors.top: headerRow.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 16

        // Cần có fallback model để lỡ backend chưa chạy thì UI vẫn vẽ ra để mày ngắm test
        model: (typeof sysWifi !== "undefined") ? sysWifi.networks : 0
        spacing: 8
        clip: true

        delegate: Rectangle {
            id: itemRow
            width: wifiListView.width
            height: 50 // Tăng lên 50px cho thoáng, dễ bấm
            radius: 10

            // Hiệu ứng kính mờ (Glassmorphism) đổi màu nhẹ khi Hover chuột vào
            color: mouseAreaItem.containsMouse
                ? Qt.rgba(1, 1, 1, 0.08)
                : Qt.rgba(1, 1, 1, 0.03)

            border.color: modelData.isConnected ? Qt.rgba(0.71, 0.91, 0.69, 0.2) : "transparent"
            border.width: 1

            // Trực quan hóa vùng tương tác của cả hàng
            MouseArea {
                id: mouseAreaItem
                anchors.fill: parent
                hoverEnabled: true
            }

            Row {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 12

                // Icon Wi-Fi trạng thái (Màu xanh nếu đang kết nối)
                Text {
                    text: "" // Ký tự Awesome Font hoặc biểu tượng wifi thế mạng
                    font.pixelSize: 14
                    color: modelData.isConnected ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.6)
                    anchors.verticalCenter: parent.verticalCenter
                }

                // Tên mạng SSID
                Text {
                    text: modelData.ssid
                    font.pixelSize: 13
                    font.weight: modelData.isConnected ? Font.Bold : Font.Normal
                    color: modelData.isConnected ? "#b5e8b0" : "#FFFFFF"
                    width: parent.width - connectBtn.width - 40
                    elide: Text.ElideRight
                    anchors.verticalCenter: parent.verticalCenter
                }

                // NÚT BẤM KẾT NỐI / NGẮT KẾT NỐI
                Rectangle {
                    id: connectBtn
                    width: modelData.isConnected ? 85 : 70
                    height: 28
                    radius: 6
                    anchors.verticalCenter: parent.verticalCenter

                    // Màu sắc hiện đại, dịu mắt hơn bản cũ
                    color: {
                        if (modelData.isConnected) {
                            return btnMouseArea.containsMouse ? Qt.rgba(0.9, 0.3, 0.3, 0.4) : Qt.rgba(0.9, 0.3, 0.3, 0.2)
                        } else {
                            return btnMouseArea.containsMouse ? Qt.rgba(0.71, 0.91, 0.69, 0.4) : Qt.rgba(0.71, 0.91, 0.69, 0.15)
                        }
                    }

                    border.color: modelData.isConnected ? Qt.rgba(1, 0.4, 0.4, 0.4) : Qt.rgba(0.71, 0.91, 0.69, 0.4)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: modelData.isConnected ? "Disconnect" : "Connect"
                        color: modelData.isConnected ? "#ff8787" : "#b5e8b0"
                        font.pixelSize: 11
                        font.bold: true
                    }

                    MouseArea {
                        id: btnMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (typeof sysWifi !== "undefined") {
                                if (modelData.isConnected) {
                                    sysWifi.disconnect()
                                } else {
                                    root.pendingSsid = modelData.ssid
                                    root.showPassword = true
                                }
                            } else {
                                // Log test giả lập khi chạy chay UI không có backend C++
                                console.log("Click mạng: " + modelData.ssid)
                            }
                        }
                    }
                }
            }
        }
    }
}