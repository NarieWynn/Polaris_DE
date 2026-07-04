import QtQuick

Rectangle {
    id: root
    width: batteryRow.width + 16
    height: parent ? parent.height : 0
    color: "#b5e8b0"
    radius: 10

    Row {
        id: batteryRow
        spacing: 6
        anchors.centerIn: parent

        Text {
            id: batteryIcon
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
            text: sysBattery.isCharging ? "󱐋" :
                (sysBattery.batteryLevel > 80 ? " " :
                        sysBattery.batteryLevel > 50 ? " " :
                            sysBattery.batteryLevel > 20 ? " " : " ")
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: batteryText
            text: sysBattery.batteryLevel + "%"
            color: sysBattery.isCharging ? "#00FF7F" :
                (sysBattery.batteryLevel <= 20 ? "#FF6347" : "#4a4a4a")
            font.pixelSize: 13
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}