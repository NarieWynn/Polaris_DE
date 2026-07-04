import QtQuick

Row {
    id: root
    spacing: 6

    Repeater {
        model: 5

        Rectangle {
            property bool isActive: (index + 1) === Math.min(sysWorkspace.activeWorkspace, 5)
            property bool isLast: index === 4 && sysWorkspace.activeWorkspace > 5

            width: isActive || isLast ? 16 : 8
            height: isActive || isLast ? 16 : 8
            radius: width / 2
            color: isActive || isLast
                ? Qt.rgba(0.71, 0.91, 0.69, 0.9)
                : Qt.rgba(1, 1, 1, 0.3)
            anchors.verticalCenter: parent.verticalCenter

            Behavior on width { NumberAnimation { duration: 200 } }
            Behavior on height { NumberAnimation { duration: 200 } }

            Text {
                anchors.centerIn: parent
                text: {
                    if (index === 4 && sysWorkspace.activeWorkspace > 5)
                        return sysWorkspace.activeWorkspace.toString()
                    if ((index + 1) === sysWorkspace.activeWorkspace)
                        return sysWorkspace.activeWorkspace.toString()
                    return ""
                }
                color: "#2d5a27"
                font.pixelSize: 9
                font.bold: true
            }
        }
    }
}