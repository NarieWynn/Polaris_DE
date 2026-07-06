import QtQuick
import QtQuick.Controls

Column {
    spacing: 24
    width: parent.width

    Text {
        text: "Display"
        color: "#b5e8b0"
        font.pixelSize: 20
        font.bold: true
    }

    Column {
        spacing: 8
        width: parent.width

        Row {
            spacing: 8
            Text {
                text: "󰃞  Brightness"
                color: "white"
                font.pixelSize: 14
            }
            Text {
                text: sysHardware.brightness + "%"
                color: "#b5e8b0"
                font.pixelSize: 14
                font.bold: true
            }
        }

        Slider {
            width: parent.width
            from: 0
            to: 100
            value: sysHardware.brightness
            stepSize: 1
            onMoved: sysHardware.brightness = value
        }
    }
}