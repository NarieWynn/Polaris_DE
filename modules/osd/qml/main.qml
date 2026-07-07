import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root
    width: 240
    height: 40

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0.03, 0.05, 0.04, 0.88)
        radius: height / 2
        border.color: Qt.rgba(0.71, 0.91, 0.69, 0.2)
        border.width: 1

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.5)
            shadowBlur: 0.6
            shadowVerticalOffset: 3
        }

        Row {
            anchors.centerIn: parent
            spacing: 12

            Text {
                text: {
                    if (osdMode === "volume") {
                        const v = hardwareManager.volume
                        if (v === 0) return "󰝟"       // muted
                        else if (v < 50) return "󰖀"   // low
                        else return "󰕾"                // high
                    }
                    return "󰃠" // brightness
                }
                font.pixelSize: 16
                font.family: "JetBrainsMono Nerd Font"
                color: "#b5e8b0"
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 150
                height: 5
                radius: 2.5
                color: Qt.rgba(1, 1, 1, 0.12)
                anchors.verticalCenter: parent.verticalCenter

                Rectangle {
                    width: (osdMode === "volume" ? hardwareManager.volume : hardwareManager.brightness) / 100 * parent.width
                    height: parent.height
                    radius: 2.5
                    color: "#b5e8b0"

                    Behavior on width {
                        NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                    }
                }
            }

            Text {
                text: (osdMode === "volume" ? hardwareManager.volume : hardwareManager.brightness) + "%"
                font.bold: true
                font.pixelSize: 12
                font.family: "JetBrainsMono Nerd Font"
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                width: 32
            }
        }
    }

    Timer {
        id: closeTimer
        interval: 2000
        running: true
        repeat: false
        onTriggered: fadeAnimator.start()
    }

    OpacityAnimator {
        id: fadeAnimator
        target: root
        to: 0.0
        duration: 250
        onFinished: Qt.quit()
    }
}