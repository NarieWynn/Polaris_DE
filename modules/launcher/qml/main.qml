import QtQuick
import QtQuick.Controls
import "components"

Window {
    id: root
    width: 500
    height: 400
    x: (Screen.width - width) / 2
    y: Screen.height - height - 40
    visible: true
    title: "Launcher"
    color: "transparent"
    //=================================================
    //  NORMAL VIEW
    //=================================================
    SearchBar {
        id: searchInput
        width: parent.width
        onTextChanged: {
            if (!text.startsWith(">")) {
                searchProxy.setFilterFixedString(text)
            }
        }
    }


    AppLauncher {
        anchors.top: searchInput.bottom
        width: parent.width
        height: 400
        visible: !searchInput.text.startsWith(">")
    }

    //=================================================
    // COMMAND VIEW
    //=================================================
    Rectangle {
        anchors.top: searchInput.bottom
        width: parent.width
        height: 400
        visible: searchInput.text.startsWith(">")
        color: Qt.rgba(0, 0, 0, 0.6)
        radius: 16

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 8

            ListView {
                width: parent.width
                height: Math.min(contentHeight, 150)
                model: sysCmd.history
                clip: true

                delegate: Text {
                    text: "$ " + modelData
                    color: "#b5e8b0"
                    font.pixelSize: 13
                    font.family: "JetBrainsMono Nerd Font"
                }
            }

            Flickable {
                width: parent.width
                height: parent.height - y
                contentHeight: resultDisplay.height
                clip: true

                Text {
                    id: resultDisplay
                    width: parent.width
                    wrapMode: Text.WordWrap
                    color: "white"
                    font.pixelSize: 13
                    font.family: "JetBrainsMono Nerd Font"
                }
            }
        }

        Connections {
            target: sysCmd
            function onResultText(text) {
                // Nếu là chuỗi khởi đầu lệnh mới thì xóa trắng, không thì cộng dồn vào
                if (text.startsWith("🔍") || text.startsWith("❌") || text.startsWith("Usage:")) {
                    resultDisplay.text = text + "\n"
                } else {
                    resultDisplay.text += text + "\n"
                }
            }
        }

        Connections {
            target: searchInput
            function onAccepted() {
                if (searchInput.text.startsWith(">")) {
                    sysCmd.execute(searchInput.text)
                    searchInput.text = ">"
                }
            }
        }
    }
}