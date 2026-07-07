import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: root
    spacing: 14
    signal closeClicked()

    RowLayout {
        Layout.fillWidth: true

        Text {
            text: "Month " + sysCalendar.currentMonth + ", " + sysCalendar.currentYear
            color: "white"
            font.pixelSize: 16
            font.bold: true
            font.family: "JetBrainsMono Nerd Font"
            Layout.fillWidth: true
        }

        Rectangle {
            width: 54; height: 26
            radius: 8
            color: todayMouse.containsMouse ? "#b5e8b0" : Qt.rgba(0.71, 0.91, 0.69, 0.12)
            border.color: Qt.rgba(0.71, 0.91, 0.69, 0.25)
            border.width: 1

            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: "Today"
                color: todayMouse.containsMouse ? "#08130a" : "#b5e8b0"
                font.pixelSize: 11
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
            }
            MouseArea {
                id: todayMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: sysCalendar.goToToday()
            }
        }

        Rectangle {
            width: 26; height: 26
            radius: 8
            color: prevMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
            Behavior on color { ColorAnimation { duration: 150 } }
            Text {
                anchors.centerIn: parent
                text: "❮"
                color: "white"
                font.pixelSize: 12
                font.family: "JetBrainsMono Nerd Font"
            }
            MouseArea {
                id: prevMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: sysCalendar.prevMonth()
            }
        }

        Rectangle {
            width: 26; height: 26
            radius: 8
            color: nextMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
            Behavior on color { ColorAnimation { duration: 150 } }
            Text {
                anchors.centerIn: parent
                text: "❯"
                color: "white"
                font.pixelSize: 12
                font.family: "JetBrainsMono Nerd Font"
            }
            MouseArea {
                id: nextMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: sysCalendar.nextMonth()
            }
        }

        Rectangle {
            width: 26; height: 26
            radius: 8
            color: closeMouse.containsMouse ? "#FF6B6B" : "transparent"
            Behavior on color { ColorAnimation { duration: 150 } }
            Text {
                anchors.centerIn: parent
                text: "✕"
                color: closeMouse.containsMouse ? "#1a0808" : Qt.rgba(1, 1, 1, 0.6)
                font.pixelSize: 13
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
            }
            MouseArea {
                id: closeMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.closeClicked()
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Repeater {
            model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            delegate: Text {
                text: modelData
                color: Qt.rgba(1, 1, 1, 0.4)
                font.pixelSize: 12
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }
        }
    }

    GridLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        columns: 7
        rowSpacing: 2
        columnSpacing: 2

        Repeater {
            model: sysCalendar.daysGrid

            delegate: Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 36

                Rectangle {
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height) - 4
                    height: width
                    radius: width / 2

                    color: modelData.isToday
                        ? "#b5e8b0"
                        : (dayMouse.containsMouse ? Qt.rgba(0.71, 0.91, 0.69, 0.12) : "transparent")

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.dayNumber
                        font.pixelSize: 13
                        font.bold: true
                        font.family: "JetBrainsMono Nerd Font"
                        color: modelData.isToday
                            ? "#08130a"
                            : (modelData.isCurrentMonth ? "white" : Qt.rgba(1, 1, 1, 0.25))
                    }

                    MouseArea {
                        id: dayMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: console.log("clicked: " + modelData.dateString)
                    }
                }
            }
        }
    }
}