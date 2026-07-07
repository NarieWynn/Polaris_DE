import QtQuick

Item {
    id: root

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
                    font.family: "JetBrainsMono Nerd Font"
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: appModelSource.launchApp(exec)
            }
        }

        // Empty state khi không tìm thấy app nào
        Text {
            anchors.centerIn: parent
            visible: listView.count === 0
            text: "No apps found"
            color: Qt.rgba(1, 1, 1, 0.3)
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font"
        }
    }
}