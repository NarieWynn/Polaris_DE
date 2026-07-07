import QtQuick

Item {
    id: root
    implicitWidth: batteryRow.width
    implicitHeight: batteryRow.height

    Row {
        id: batteryRow
        anchors.centerIn: parent
        spacing: 6

        Text {
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 15
            font.bold: true
            color: sysBattery.isCharging ? "#7CFFB2" :
                (sysBattery.batteryLevel <= 20 ? "#FF6B6B" : Qt.rgba(1, 1, 1, 0.6))
            text: sysBattery.isCharging ? "󱐋" :
                (sysBattery.batteryLevel >= 80 ? "󰁹" :
                        sysBattery.batteryLevel > 50 ? "󰁾" :
                            sysBattery.batteryLevel > 20 ? "󰁼" : "󰂎")
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: sysBattery.batteryLevel + "%"
            color: sysBattery.isCharging ? "#7CFFB2" :
                (sysBattery.batteryLevel <= 20 ? "#FF6B6B" : "white")
            font.pixelSize: 12
            font.bold: true
            font.family: "JetBrainsMono Nerd Font"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}