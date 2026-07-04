import QtQuick

Row {
    id: root
    spacing: 6

    Repeater {
        model: 5

        Rectangle {
            width: index === 0 ? 16 : 8
            height: index === 0 ? 16 : 8
            radius: width / 2
            color: index === 0 ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.3)
            anchors.verticalCenter: parent.verticalCenter

            Behavior on width {
                NumberAnimation { duration: 200 }
            }
            Behavior on height {
                NumberAnimation { duration: 200 }
            }

            Text {
                anchors.centerIn: parent
                text: index === 0 ? "1" : ""
                color: "#2d5a27"
                font.pixelSize: 9
                font.bold: true
            }
        }
    }
}