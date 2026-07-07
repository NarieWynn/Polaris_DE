import QtQuick
import QtQuick.Controls

Item {
    id: root
    anchors.fill: parent

    // Internal properties for state management
    property string pendingSsid: ""
    property bool showPasswordPopup: false
    property bool wifiEnabled: true

    Component.onCompleted: {
        // Initialize network scan upon component completion
        if (typeof sysWifi !== "undefined" && sysWifi && typeof sysWifi.scan === "function") {
            sysWifi.scan()
        }
    }

    // Header section containing the title and master radio toggle
    Item {
        id: headerArea
        width: parent.width
        height: 40
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        Text {
            text: "Wi-Fi Network"
            color: "#FFFFFF"
            font.pixelSize: 22
            font.bold: true
            font.family: "JetBrainsMono Nerd Font"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
        }

        Switch {
            id: wifiSwitch
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            checked: root.wifiEnabled
            onCheckedChanged: {
                root.wifiEnabled = checked
                if (typeof sysWifi !== "undefined" && sysWifi && typeof sysWifi.setWifiEnabled === "function") {
                    sysWifi.setWifiEnabled(checked)
                }
            }

            indicator: Rectangle {
                implicitWidth: 38; implicitHeight: 20
                radius: 10
                color: wifiSwitch.checked ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.1)
                border.color: wifiSwitch.checked ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.2)

                Rectangle {
                    x: wifiSwitch.checked ? 20 : 2; y: 2
                    width: 16; height: 16; radius: 8
                    color: wifiSwitch.checked ? "#1e1e2e" : "#FFFFFF"
                    Behavior on x { NumberAnimation { duration: 150 } }
                }
            }
        }
    }

    // Scanning indicator displayed only during initial acquisition
    Item {
        id: scanningIndicator
        anchors.top: headerArea.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        visible: root.wifiEnabled && wifiListView.count === 0

        Column {
            anchors.centerIn: parent
            spacing: 14

            Text {
                id: spinnerIcon
                anchors.horizontalCenter: parent.horizontalCenter
                text: "󰑐"
                color: "#b5e8b0"
                font.pixelSize: 28
                font.family: "JetBrainsMono Nerd Font"

                RotationAnimation on rotation {
                    running: scanningIndicator.visible
                    from: 0; to: 360
                    loops: Animation.Infinite
                    duration: 900
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Scanning available networks..."
                color: Qt.rgba(1, 1, 1, 0.6)
                font.pixelSize: 13
                font.family: "JetBrainsMono Nerd Font"
            }
        }
    }


    // Network list view bound to backend model
    ListView {
        id: wifiListView
        anchors.top: headerArea.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 16
        visible: root.wifiEnabled && wifiListView.count > 0
        clip: true
        spacing: 8

        model: (typeof sysWifi !== "undefined" && sysWifi && sysWifi.networks) ? sysWifi.networks : []

        delegate: Rectangle {
            id: itemRow
            width: wifiListView.width
            height: 52
            radius: 10
            color: mouseAreaItem.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : Qt.rgba(1, 1, 1, 0.03)
            border.color: (modelData && modelData.isConnected) ? Qt.rgba(0.71, 0.91, 0.69, 0.2) : "transparent"
            border.width: 1

            MouseArea {
                id: mouseAreaItem
                anchors.fill: parent
                hoverEnabled: true
            }

            Row {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 14

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                    color: (modelData && modelData.isConnected) ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.6)
                    text: {
                        let strength = (modelData && typeof modelData.signalStrength !== "undefined") ? modelData.signalStrength : 100;
                        if (strength >= 75) return "󰤨"
                        if (strength >= 50) return "󰤥"
                        if (strength >= 25) return "󰤢"
                        return "󰤟"
                    }
                }

                Row {
                    width: parent.width - connectBtn.width - 40
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Text {
                        text: modelData ? modelData.ssid : "Unknown Network"
                        font.pixelSize: 13
                        font.bold: modelData && modelData.isConnected
                        font.family: "JetBrainsMono Nerd Font"
                        color: (modelData && modelData.isConnected) ? "#b5e8b0" : "#FFFFFF"
                        elide: Text.ElideRight
                    }

                    Text {
                        text: "󰌾"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        color: Qt.rgba(1, 1, 1, 0.3)
                        visible: modelData && typeof modelData.isProtected !== "undefined" && modelData.isProtected && !modelData.isConnected
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Rectangle {
                    id: connectBtn
                    width: (modelData && modelData.isConnected) ? 85 : 70
                    height: 28
                    radius: 6
                    anchors.verticalCenter: parent.verticalCenter
                    color: (modelData && modelData.isConnected)
                        ? (btnMouseArea.containsMouse ? Qt.rgba(0.9, 0.3, 0.3, 0.3) : Qt.rgba(0.9, 0.3, 0.3, 0.15))
                        : (btnMouseArea.containsMouse ? Qt.rgba(0.71, 0.91, 0.69, 0.3) : Qt.rgba(0.71, 0.91, 0.69, 0.12))
                    border.color: (modelData && modelData.isConnected) ? Qt.rgba(1, 0.4, 0.4, 0.3) : Qt.rgba(0.71, 0.91, 0.69, 0.3)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: (modelData && modelData.isConnected) ? "Disconnect" : "Connect"
                        color: (modelData && modelData.isConnected) ? "#ff8787" : "#b5e8b0"
                        font.pixelSize: 11
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                    }

                    MouseArea {
                        id: btnMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if (!modelData) return;

                            if (modelData.isConnected) {
                                if (typeof sysWifi !== "undefined" && sysWifi && typeof sysWifi.disconnect === "function") {
                                    sysWifi.disconnect()
                                }
                            } else {
                                root.pendingSsid = modelData.ssid
                                let hasPass = typeof modelData.isProtected !== "undefined" ? modelData.isProtected : true;
                                if (hasPass) {
                                    root.showPasswordPopup = true
                                } else {
                                    if (typeof sysWifi !== "undefined" && sysWifi && typeof sysWifi.connectTo === "function") {
                                        sysWifi.connectTo(modelData.ssid, "")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Hardware interface status indicator
    Text {
        anchors.centerIn: parent
        visible: !root.wifiEnabled
        text: "󰤮  Wi-Fi Hardware Interface Disabled"
        color: Qt.rgba(1, 1, 1, 0.3)
        font.pixelSize: 14
        font.family: "JetBrainsMono Nerd Font"
    }

    // Authentication modal
    Popup {
        id: passwordModal
        visible: root.showPasswordPopup
        anchors.centerIn: parent
        width: 320; height: 180; modal: true; focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        onClosed: { root.showPasswordPopup = false; passInput.text = "" }

        background: Rectangle {
            color: "#1e1e2e"; radius: 12; border.color: Qt.rgba(1, 1, 1, 0.1); border.width: 1
        }

        Column {
            anchors.fill: parent; anchors.margins: 16; spacing: 14

            Text {
                text: "Connect to " + root.pendingSsid
                color: "white"; font.pixelSize: 14; font.bold: true
                font.family: "JetBrainsMono Nerd Font"
            }

            Rectangle {
                width: parent.width; height: 36; radius: 6; color: Qt.rgba(1, 1, 1, 0.05)
                border.color: passInput.activeFocus ? "#b5e8b0" : Qt.rgba(1, 1, 1, 0.1)

                TextField {
                    id: passInput
                    anchors.fill: parent; anchors.leftMargin: 10; anchors.rightMargin: 10
                    verticalAlignment: TextInput.AlignVCenter
                    color: "white"; font.pixelSize: 12
                    echoMode: TextInput.Password
                    placeholderText: "Enter Wi-Fi password"
                    placeholderTextColor: Qt.rgba(1, 1, 1, 0.3)
                    background: null
                }
            }

            Row {
                width: parent.width; height: 32; spacing: 10

                Rectangle {
                    width: parent.width / 2 - 5; height: parent.height; radius: 6
                    color: Qt.rgba(1, 1, 1, 0.05)
                    Text { text: "Cancel"; color: "white"; font.pixelSize: 12; anchors.centerIn: parent }
                    MouseArea { anchors.fill: parent; onClicked: passwordModal.close() }
                }

                Rectangle {
                    width: parent.width / 2 - 5; height: parent.height; radius: 6
                    color: "#b5e8b0"
                    Text { text: "Connect"; color: "#1e1e2e"; font.pixelSize: 12; font.bold: true; anchors.centerIn: parent }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (typeof sysWifi !== "undefined" && sysWifi && typeof sysWifi.connectTo === "function") {
                                sysWifi.connectTo(root.pendingSsid, passInput.text)
                            }
                            passwordModal.close()
                        }
                    }
                }
            }
        }
    }
}