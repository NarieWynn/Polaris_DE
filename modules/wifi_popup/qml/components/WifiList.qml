import QtQuick
import QtQuick.Controls

Item {
    id: root
    width: 240
    height: childrenRect.height

    property string pendingSsid: ""
    property bool showPassword: false

    Timer {
        id: popupRealtimeScanTimer
        interval: 4000
        repeat: true
        running: root.visible

        onTriggered: {
            sysWifi.scan()
        }
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
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "✕"
                color: Qt.rgba(1, 1, 1, 0.6)
                font.pixelSize: 16
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: Window.window.visible = false
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
                            color: modelData.isConnected ? "#ff6b6b" : "#b5e8b0"
                            font.pixelSize: 10
                            font.bold: true
                        }

                        MouseArea {
                            anchors.fill: parent
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
                text: "← " + root.pendingSsid
                color: "white"
                font.pixelSize: 13
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: root.showPassword = false
                }
            }

            Text {
                text: "✕"
                color: Qt.rgba(1, 1, 1, 0.6)
                font.pixelSize: 16
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    onClicked: Window.window.visible = false
                }
            }
        }

        TextField {
            id: passwordInput
            width: parent.width
            height: 36
            placeholderText: "Password..."
            echoMode: TextInput.Password
            color: "white"
            background: Rectangle {
                color: Qt.rgba(1, 1, 1, 0.1)
                radius: 6
            }
        }

        Rectangle {
            width: parent.width
            height: 36
            radius: 6
            color: Qt.rgba(0.71, 0.91, 0.69, 0.7)

            Text {
                anchors.centerIn: parent
                text: "Connect"
                color: "#2d5a27"
                font.bold: true
                font.pixelSize: 13
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    sysWifi.connectTo(root.pendingSsid, passwordInput.text)
                    passwordInput.text = ""
                    root.showPassword = false
                }
            }
        }
    }
}