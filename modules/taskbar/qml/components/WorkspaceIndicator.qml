import QtQuick

Item {
    id: root

    readonly property int dotSize: 8
    readonly property int spacing: 10
    readonly property int pillSize: 18
    readonly property int targetIndex: Math.min(sysWorkspace.activeWorkspace, 5) - 1

    width: dotsRow.width
    height: pillSize

    // Pill mint trượt mượt tới vị trí workspace đang active
    Rectangle {
        id: activePill
        width: pillSize
        height: pillSize
        radius: pillSize / 2
        color: Qt.rgba(0.71, 0.91, 0.69, 0.9)
        anchors.verticalCenter: parent.verticalCenter
        x: root.targetIndex * (root.dotSize + root.spacing) + root.dotSize / 2 - width / 2

        Behavior on x {
            NumberAnimation { duration: 280; easing.type: Easing.OutCubic }
        }

        Text {
            anchors.centerIn: parent
            text: sysWorkspace.activeWorkspace.toString()
            color: "#08130a"
            font.pixelSize: 9
            font.bold: true
            font.family: "JetBrainsMono Nerd Font"
        }
    }

    Row {
        id: dotsRow
        spacing: root.spacing
        anchors.verticalCenter: parent.verticalCenter

        Repeater {
            model: 5

            Rectangle {
                width: root.dotSize
                height: root.dotSize
                radius: width / 2
                anchors.verticalCenter: parent.verticalCenter
                color: Qt.rgba(1, 1, 1, 0.3)

                // Ẩn chấm nhỏ tại vị trí pill đang đứng, để lộ pill mint bên dưới
                opacity: index === root.targetIndex ? 0 : 1
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }
        }
    }
}