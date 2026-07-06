import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "transparent"

        Column {
            anchors.centerIn: parent
            spacing: 16

            // Icon Nerd Font bay bổng phát sáng nhẹ
            Text {
                text: "󰔚"
                color: "#b5e8b0"
                font.pixelSize: 64
                anchors.horizontalCenter: parent.horizontalCenter

                // Hiệu ứng thở (Blinking animation) cho icon nhìn cho sống động
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.4; to: 1.0; duration: 1500; easing.type: Easing.InOutQuad }
                    NumberAnimation { from: 1.0; to: 0.4; duration: 1500; easing.type: Easing.InOutQuad }
                }
            }

            Text {
                text: "Feature Coming Soon"
                color: "white"
                font.pixelSize: 20
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "This advanced module is currently under heavy development.\nPolaris Isolation & Network Engine will be deployed in the next sub-system update."
                color: Qt.rgba(1, 1, 1, 0.4)
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                lineHeight: 1.4
                font.family: "JetBrainsMono Nerd Font"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}