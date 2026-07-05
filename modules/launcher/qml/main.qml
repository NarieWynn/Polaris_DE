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
    color: Qt.rgba(0.04, 0.08, 0.05, 0.75)
    
    onVisibleChanged: {
        if (visible) {
            searchInput.forceActiveFocus()
        }
    }

    property bool commandMode: searchInput.text.startsWith(">")

    //=================================================
    // SEARCH BAR
    //=================================================
    SearchBar {
        id: searchInput
        onTextChanged: {
            if (!text.startsWith(">")) {
                searchProxy.setFilterFixedString(text)
            } else if (text === ">") {
                commandInput.forceActiveFocus()
            }
        }
    }

    //=================================================
    // NORMAL VIEW
    //=================================================
    AppLauncher {
        anchors.top: searchInput.bottom
        width: parent.width
        height: 400
        visible: !root.commandMode
    }

    //=================================================
    // COMMAND VIEW
    //=================================================
    Rectangle {
        id: commandContainer
        anchors.top: searchInput.bottom
        width: parent.width
        height: 400
        visible: root.commandMode
        color: Qt.rgba(0, 0, 0, 0.6)
        radius: 16

        Column {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Row {
                id: inputRow
                width: parent.width
                spacing: 6

                Text {
                    text: "$"
                    color: "#b5e8b0"
                    font.pixelSize: 13
                    font.family: "JetBrainsMono Nerd Font"
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: commandInput
                    width: parent.width - 20
                    color: "white"
                    font.pixelSize: 13
                    font.family: "JetBrainsMono Nerd Font"
                    placeholderText: "type command..."
                    background: Rectangle { color: "transparent" }
                    focus: true

                    onAccepted: {
                        if (text.length === 0) return

                        resultDisplay.text += "<span style='color:#b5e8b0'>$ </span><span style='color:white'>" + text + "</span><br>"
                        sysCmd.execute(text)
                        text = ""
                    }

                    Keys.onTabPressed: {
                        const suggestions = sysCmd.getSuggestions(text)
                        if (suggestions.length > 0) {
                            text = suggestions[0]
                        }
                    }

                    Keys.onUpPressed: {
                        if (sysCmd.history.length > 0) {
                            text = sysCmd.history[sysCmd.history.length - 1]
                        }
                    }

                    Keys.onEscapePressed: {
                        searchInput.text = ""
                        searchInput.forceActiveFocus()
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Qt.rgba(181, 232, 176, 0.2)
            }
            Flickable {
                id: terminalFlickable
                width: parent.width
                height: parent.height - inputRow.height - 35
                contentHeight: resultDisplay.height
                clip: true

                Text {
                    id: resultDisplay
                    width: parent.width
                    wrapMode: Text.WordWrap
                    textFormat: Text.StyledText
                    color: "white"
                    font.pixelSize: 13
                    font.family: "JetBrainsMono Nerd Font"
                    text: "<span style='color:#e3c38c'> Type help for list of command.</span><br><span style='color:#8fa0a8'>Ready for commands...</span><br><br>"
                }
                onContentHeightChanged: {
                    terminalFlickable.contentY = Math.max(0, contentHeight - height)
                }
            }
        }

        Connections {
            target: sysCmd
            function onResultText(text) {
                resultDisplay.text += "<span style='color:white'>" + text + "</span><br>"

                resultDisplay.text += "<span style='color:rgba(181,232,176,0.15)'>===================================================</span><br>"
            }
        }
    }
}