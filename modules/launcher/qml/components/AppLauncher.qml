import QtQuick

Item {
    id: root

    ListView {
        anchors.fill: parent
        model: appModel
        delegate: Text {
            text: name
            color: "white"
            font.pixelSize: 18
        }
    }
}