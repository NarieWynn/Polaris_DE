import QtQuick

Rectangle {
    id: root
    width: wifiRow.width + 16
    height: parent ? parent.height : 0
    color: Qt.rgba(0.71, 0.91, 0.69, 0.7)
    radius: 10

    Row {
        id: wifiRow
        spacing: 4
        anchors.centerIn: parent

        Text {
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 25
            color: "#2d5a27"
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            text: sysWifi.isConnected ? "󰖩" : "󰖪"
        }

        Text {
            font.pixelSize: 12
            font.bold: true
            color: "#2d5a27"
            anchors.verticalCenter: parent.verticalCenter
            text: sysWifi.isConnected ? sysWifi.ssid : "No WiFi"
        }
    }
}