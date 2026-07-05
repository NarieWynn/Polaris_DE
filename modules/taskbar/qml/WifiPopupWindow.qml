import QtQuick
import QtQuick.Controls
import "components"

Window {
    id: wifiPopupWindow
    width: 240
    height: 300
    visible: false
    color: "transparent"
    title: "wifi_popup"

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: Qt.rgba(0, 0, 0, 0.85)
        border.color: Qt.rgba(1, 1, 1, 0.1)
        border.width: 1

        WifiPopup {
            anchors.fill: parent
            anchors.margins: 8
            onClose: wifiPopupWindow.visible = false
        }
    }
}