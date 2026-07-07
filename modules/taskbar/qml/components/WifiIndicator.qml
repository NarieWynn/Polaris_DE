import QtQuick

Item {
    id: root
    implicitWidth: wifiRow.width
    implicitHeight: wifiRow.height

    Row {
        id: wifiRow
        anchors.centerIn: parent
        spacing: 6

        Text {
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 15
            font.bold: true
            color: sysWifi.isConnected ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.35)
            text: sysWifi.isConnected ? "󰖩" : "󰖪"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            font.pixelSize: 12
            font.bold: true
            color: sysWifi.isConnected ? "white" : Qt.rgba(1, 1, 1, 0.35)
            font.family: "JetBrainsMono Nerd Font"
            text: sysWifi.isConnected ? sysWifi.ssid : "No WiFi"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: sysWifi.togglePopup()
    }
}