import QtQuick
import QtQuick.Controls
import "components"
Window {
    id: root
    width: 500
    height: 600
    visible: true
    title: "Launcher"
    color: "#1e1e2e"

    SearchBar {
        id: searchInput
        width: parent.width
    }
    AppLauncher {
        anchors.top: searchInput.bottom
        width: parent.width
        height: 300
    }
}
