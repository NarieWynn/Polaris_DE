import QtQuick
import QtQuick.Controls
import "components"

Window {
    id: root
    width: 240
    height: 300
    visible: false
    title: "wifi_popup"
    color: "transparent"
    //flags: Qt.Popup

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Qt.rgba(0, 0, 0, 0.85)
        border.color: Qt.rgba(1, 1, 1, 0.1)
        border.width: 1

        WifiList {
            anchors.fill: parent
            anchors.margins: 8
        }
    }
    onActiveChanged: {
       if (!active) Qt.quit()
    }
}