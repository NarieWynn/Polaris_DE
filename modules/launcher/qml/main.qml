import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "components"

Window {
    id: root
    width: 640
    height: 480
    x: (Screen.width - width) / 2
    y: Screen.height * 0.14
    visible: true
    title: "Launcher"
    color: "transparent"

    property bool commandMode: searchInput.text.startsWith(">")

    onVisibleChanged: {
        if (visible) {
            searchInput.forceActiveFocus()
        }
    }

    //=================================================
    // GLASS PANEL
    //=================================================
    Rectangle {
        id: panel
        anchors.fill: parent
        radius: 20
        color: Qt.rgba(0.03, 0.05, 0.04, 0.94)
        border.color: Qt.rgba(0.71, 0.91, 0.69, 0.18)
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            //=================================================
            // SEARCH ROW
            //=================================================
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 68

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 16
                    spacing: 14

                    Text {
                        text: root.commandMode ? "$" : "\uf002" // nf-fa-search
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 18
                        color: root.commandMode ? "#e3c38c" : "#b5e8b0"
                        Layout.alignment: Qt.AlignVCenter

                        Behavior on color { ColorAnimation { duration: 150 } }
                    }

                    SearchBar {
                        id: searchInput
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter

                        onTextChanged: {
                            if (!text.startsWith(">")) {
                                searchProxy.setFilterFixedString(text)
                            } else if (text === ">") {
                                commandInput.forceActiveFocus()
                            }
                        }
                    }

                    Rectangle {
                        visible: root.commandMode
                        Layout.preferredWidth: badgeText.implicitWidth + 16
                        Layout.preferredHeight: 22
                        radius: 11
                        color: Qt.rgba(0.89, 0.76, 0.55, 0.15)
                        border.color: Qt.rgba(0.89, 0.76, 0.55, 0.35)
                        border.width: 1

                        Text {
                            id: badgeText
                            anchors.centerIn: parent
                            text: "COMMAND"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 10
                            font.bold: true
                            color: "#e3c38c"
                        }
                    }
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(0.71, 0.91, 0.69, 0.12)
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // NORMAL VIEW
                AppLauncher {
                    anchors.fill: parent
                    visible: !root.commandMode
                }

                // COMMAND VIEW
                Item {
                    id: commandContainer
                    anchors.fill: parent
                    visible: root.commandMode

                    property string committedText: "<span style='color:#e3c38c'>Type help for list of commands.</span><br><span style='color:#8fa0a8'>Ready for commands...</span><br><br>"
                    property var typeQueue: []
                    property bool isTyping: false
                    property bool cursorPhase: true

                    function redraw() {
                        const cursor = isTyping
                            ? (cursorPhase ? "<span style='color:#b5e8b0'>▋</span>" : "<span style='color:transparent'>▋</span>")
                            : ""
                        resultDisplay.text = committedText + cursor

                    }

                    function enqueueTyping(html) {
                        const tokens = html.match(/(<[^>]+>)|([^<]+)/g) || []
                        for (let i = 0; i < tokens.length; i++) {
                            const t = tokens[i]
                            if (t.charAt(0) === "<") {
                                typeQueue.push(t)
                            } else {
                                for (let j = 0; j < t.length; j++) {
                                    typeQueue.push(t.charAt(j))
                                }
                            }
                        }
                        isTyping = true
                        typingTimer.start()
                    }

                    Timer {
                        id: typingTimer
                        interval: 10
                        repeat: true
                        onTriggered: {
                            if (commandContainer.typeQueue.length === 0) {
                                commandContainer.isTyping = false
                                typingTimer.stop()
                                commandContainer.redraw()
                                return
                            }
                            commandContainer.committedText += commandContainer.typeQueue.shift()
                            commandContainer.redraw()
                        }
                    }

                    Timer {
                        id: cursorBlinkTimer
                        interval: 450
                        repeat: true
                        running: true
                        onTriggered: {
                            commandContainer.cursorPhase = !commandContainer.cursorPhase
                            if (commandContainer.isTyping) commandContainer.redraw()
                        }
                    }

                    Component.onCompleted: redraw()

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 10

                        Row {
                            id: inputRow
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: "\uf105" // nf-fa-angle_right
                                color: "#b5e8b0"
                                font.pixelSize: 13
                                font.family: "JetBrainsMono Nerd Font"
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            TextField {
                                id: commandInput
                                width: parent.width - 24
                                color: "white"
                                font.pixelSize: 13
                                font.family: "JetBrainsMono Nerd Font"
                                placeholderText: "type command..."
                                background: Rectangle { color: "transparent" }
                                focus: true

                                onAccepted: {
                                    if (text.length === 0) return

                                    commandContainer.committedText += "<span style='color:#b5e8b0'>&gt; </span><span style='color:white'>" + text + "</span><br>"
                                    commandContainer.redraw()
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
                            Layout.fillWidth: true
                            height: 1
                            color: Qt.rgba(0.71, 0.91, 0.69, 0.15)
                        }

                        Flickable {
                            id: terminalFlickable
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            contentWidth: width
                            contentHeight: resultDisplay.implicitHeight + 24
                            clip: true

                            Text {
                                id: resultDisplay
                                width: terminalFlickable.width
                                wrapMode: Text.WordWrap
                                textFormat: Text.StyledText
                                color: "white"
                                font.pixelSize: 13
                                font.family: "JetBrainsMono Nerd Font"
                            }
                            onContentHeightChanged: {
                                terminalFlickable.contentY = Math.max(0, implicitHeight - terminalFlickable.height + 24)
                            }
                        }
                    }

                    Connections {
                        target: sysCmd
                        function onResultText(text) {
                            commandContainer.enqueueTyping(
                                "<span style='color:white'>" + text + "</span><br>" +
                                "<span style='color:rgba(181,232,176,0.15)'>===================================================</span><br>"
                            )
                        }
                    }
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Qt.rgba(0.71, 0.91, 0.69, 0.1)
            }

            //=================================================
            // FOOTER
            //=================================================
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 38

                RowLayout {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 16

                    RowLayout {
                        spacing: 5
                        Text { text: "↵"; color: Qt.rgba(0.71, 0.91, 0.69, 0.6); font.pixelSize: 11; font.family: "JetBrainsMono Nerd Font" }
                        Text { text: "Open"; color: Qt.rgba(1, 1, 1, 0.4); font.pixelSize: 11; font.family: "JetBrainsMono Nerd Font" }
                    }
                    RowLayout {
                        spacing: 5
                        Text { text: "⇥"; color: Qt.rgba(0.71, 0.91, 0.69, 0.6); font.pixelSize: 11; font.family: "JetBrainsMono Nerd Font" }
                        Text { text: "Autocomplete"; color: Qt.rgba(1, 1, 1, 0.4); font.pixelSize: 11; font.family: "JetBrainsMono Nerd Font" }
                    }
                    RowLayout {
                        spacing: 5
                        Text { text: ">"; color: Qt.rgba(0.89, 0.76, 0.55, 0.7); font.pixelSize: 11; font.family: "JetBrainsMono Nerd Font"; font.bold: true }
                        Text { text: "Command mode"; color: Qt.rgba(1, 1, 1, 0.4); font.pixelSize: 11; font.family: "JetBrainsMono Nerd Font" }
                    }
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Polaris"
                    color: Qt.rgba(0.71, 0.91, 0.69, 0.35)
                    font.pixelSize: 11
                    font.bold: true
                    font.family: "JetBrainsMono Nerd Font"
                }
            }
        }
    }
}
