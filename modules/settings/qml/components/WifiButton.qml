import QtQuick
import QtQuick.Effects

Item {
    id: root

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 16
        color: Qt.rgba(1, 1, 1, 0.3)        // sáng hơn, 30% trắng
        border.color: Qt.rgba(1, 1, 1, 0.6)
        border.width: 1

        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 0.6
            blurMax: 32
        }
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 12
        spacing: 12

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "Wi-Fi"
            color: "#333333"  // chữ tối trên nền sáng
            font.pixelSize: 15
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: console.log("wifi clicked")
    }
}