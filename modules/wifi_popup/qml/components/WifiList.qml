import QtQuick

Column {
    id: root
    spacing: 4

    // Header
    Text {
        text: "Wi-Fi"
        color: "white"
        font.pixelSize: 14
        font.bold: true
        leftPadding: 8
    }

    // Danh sách wifi hardcode tạm
    Repeater {
        model: ["NGUYEN", "KS Gia Phu 3", "HUNG PHUC", "VIETTEL"]

        Rectangle {
            width: root.width
            height: 40
            radius: 8
            color: mouseArea.containsMouse
                ? Qt.rgba(1, 1, 1, 0.1)
                : "transparent"

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 8
                spacing: 8

                Text {
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                    color: "white"
                    text: "󰖩"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    font.pixelSize: 12
                    color: modelData === sysWifi.ssid ? "#b5e8b0" : "white"
                    font.bold: modelData === sysWifi.ssid
                    text: modelData
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: console.log("connect: " + modelData)
            }
        }
    }
}