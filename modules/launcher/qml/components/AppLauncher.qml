import QtQuick
import QtQuick.Effects

Item {
    id: root

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 16
        color: "transparent"
        border.color: Qt.rgba(0.71, 0.91, 0.69, 0.2)
        border.width: 1

        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 0.4
            blurMax: 32
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.margins: 8
        clip: true
        model: appModel
        spacing: 4

        delegate: Rectangle {
            width: listView.width
            height: 48
            radius: 10
            color: mouseArea.containsMouse
                ? Qt.rgba(0.71, 0.91, 0.69, 0.15)
                : "transparent"

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 12
                spacing: 12

                Rectangle {
                    width: 32
                    height: 32
                    radius: 8
                    color: Qt.rgba(0.71, 0.91, 0.69, 0.2)

                    Text {
                        anchors.centerIn: parent
                        text: name.charAt(0).toUpperCase()
                        color: "#b5e8b0"
                        font.pixelSize: 16
                        font.bold: true
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: name
                    color: "white"
                    font.pixelSize: 15
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: appModelSource.launchApp(exec)
            }
        }
    }
}