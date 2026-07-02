import QtQuick
import QtQuick.Controls
import "components"
Window {
    id: root
    width: 500
    height: 400
    x: (Screen.width - width) / 2 //no effect because of hyprland
    y: Screen.height - height - 40 // need to config in hyprland.lua
    visible: true
    title: "Launcher"
    color: "#1e1e2e"

    SearchBar {
        id: searchInput
        width: parent.width
        onTextChanged: searchProxy.setFilterFixedString(text)
    }
    AppLauncher {
        anchors.top: searchInput.bottom
        width: parent.width
        height: 400
    }
}
