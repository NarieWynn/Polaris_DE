import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 240
    height: childrenRect.height

        signal close

    property string pendingSsid: ""
    property bool showPassword: false

    Timer {
        id: popupRealtimeScanTimer
        interval: 4000
        repeat: true
        running: root.visible
        onTriggered: sysWifi.scan()
    }

    Column {
        id: mainColumn
        width: parent.width
        spacing: 4
        visible: !root.showPassword

        Timer {
            interval: 100
            running: true
            repeat: false
            onTriggered: sysWifi.scan()
        }

        Item {
            width: parent.width
            height: 30

            Text {
                text: "Wi-Fi"
                color: "white"
                font.pixelSize: 14
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 26; height: 26
                radius: 8
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: closeWifiMouse.containsMouse ? "#FF6B6B" : "transparent"
                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    color: closeWifiMouse.containsMouse ? "#1a0808" : Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 14
                    font.bold: true
                    font.family: "JetBrainsMono Nerd Font"
                }

                MouseArea {
                    id: closeWifiMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.close()
                }
            }
        }

        ListView {
            width: parent.width
            height: Math.min(contentHeight, 250)
            model: sysWifi.networks
            spacing: 4
            clip: true

            delegate: Rectangle {
                width: mainColumn.width
                height: 40
                radius: 8
                color: Qt.rgba(1, 1, 1, 0.05)

                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 12
                        font.family: "JetBrainsMono Nerd Font"
                        color: modelData.isConnected ? "#b5e8b0" : "white"
                        text: modelData.ssid
                        width: parent.width - connectBtn.width - 8
                        elide: Text.ElideRight
                    }

                    Rectangle {
                        id: connectBtn
                        anchors.verticalCenter: parent.verticalCenter
                        width: modelData.isConnected ? 80 : 65
                        height: 24
                        radius: 12
                        color: modelData.isConnected
                            ? Qt.rgba(1, 0.4, 0.4, 0.3)
                            : Qt.rgba(0.71, 0.91, 0.69, 0.3)

                        Text {
                            anchors.centerIn: parent
                            text: modelData.isConnected ? "Disconnect" : "Connect"
                            color: modelData.isConnected ? "#FF6B6B" : "#b5e8b0"
                            font.pixelSize: 10
                            font.bold: true
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (modelData.isConnected) {
                                    sysWifi.disconnect()
                                } else {
                                    root.pendingSsid = modelData.ssid
                                    root.showPassword = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Column {
        width: parent.width
        spacing: 8
        visible: root.showPassword

        Item {
            width: parent.width
            height: 30

            Text {
                text: "❮ " + root.pendingSsid
                color: "white"
                font.pixelSize: 13
                font.family: "JetBrainsMono Nerd Font"
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.showPassword = false
                }
            }

            Rectangle {
                width: 26; height: 26
                radius: 8
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: closePassWifiMouse.containsMouse ? "#FF6B6B" : "transparent"
                Behavior on color { ColorAnimation { duration: 150 } }

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    color: closePassWifiMouse.containsMouse ? "#1a0808" : Qt.rgba(1, 1, 1, 0.6)
                    font.pixelSize: 14
                    font.bold: true
                    font.family: "JetBrainsMono Nerd Font"
                }

                MouseArea {
                    id: closePassWifiMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.close()
                }
            }
        }

        TextField {
            id: passwordInput
            width: parent.width
            height: 36
            placeholderText: "Password..."
            placeholderTextColor: Qt.rgba(1, 1, 1, 0.35)
            echoMode: TextInput.Password
            color: "white"
            font.family: "JetBrainsMono Nerd Font"
            leftPadding: 12

            background: Rectangle {
                color: Qt.rgba(1, 1, 1, 0.08)
                radius: 8
                border.color: Qt.rgba(0.71, 0.91, 0.69, 0.2)
                border.width: 1
            }
        }

        Rectangle {
            width: parent.width
            height: 36
            radius: 8
            color: connectMouse.containsMouse ? Qt.rgba(0.81, 1.0, 0.79, 1) : "#b5e8b0"
            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: "Connect"
                color: "#08130a"
                font.bold: true
                font.pixelSize: 13
                font.family: "JetBrainsMono Nerd Font"
            }

            MouseArea {
                id: connectMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    sysWifi.connectTo(root.pendingSsid, passwordInput.text)
                    passwordInput.text = ""
                    root.showPassword = false
                }
            }
        }
    }
}