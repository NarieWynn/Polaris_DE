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
        radius: 20
        color: Qt.rgba(0.03, 0.05, 0.04, 0.94)
        border.color: Qt.rgba(0.71, 0.91, 0.69, 0.18)
        border.width: 1

        WifiPopup {
            anchors.fill: parent
            anchors.margins: 12
            onClose: wifiPopupWindow.visible = false
        }
    }
}