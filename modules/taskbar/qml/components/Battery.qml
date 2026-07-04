import QtQuick

Rectangle {
    id: root
    width: batteryRow.childrenRect.width + 16
    height: parent ? parent.height : 0
    color: Qt.rgba(0.71, 0.91, 0.69, 0.7)
    radius: 10

    Row {
        id: batteryRow
        spacing: 6
        anchors.centerIn: parent

        Text {
            id: batteryIcon
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
            font.bold: true
            color: sysBattery.isCharging ? "#00FF7F" :
                (sysBattery.batteryLevel <= 20 ? "#FF6347" : "#4a4a4a")


            text: sysBattery.isCharging ? "󱐋" :
                (sysBattery.batteryLevel >= 80 ? "󰁹" :
                        sysBattery.batteryLevel > 50 ? "󰁾" :
                            sysBattery.batteryLevel > 20 ? "󰁼" : "󰂎")

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