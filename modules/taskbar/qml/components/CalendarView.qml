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
            color: "#ffffff"
            font.pixelSize: 18
            font.bold: true
            Layout.fillWidth: true
        }

        Rectangle {
            width: 54; height: 26
            radius: 6
            color: todayMouse.containsMouse ? "#719169" : "#22ffffff"
            border.color: todayMouse.containsMouse ? "transparent" : "#33ffffff"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "Today"
                color: todayMouse.containsMouse ? "#0d120d" : "#ffffff"
                font.pixelSize: 11
                font.bold: true
            }
            MouseArea {
                id: todayMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: sysCalendar.goToToday()
            }
        }

        Rectangle {
            width: 26; height: 26
            radius: 6
            color: prevMouse.containsMouse ? "#33ffffff" : "transparent"
            Text { anchors.centerIn: parent; text: "❮"; color: "#ffffff"; font.pixelSize: 12 }
            MouseArea { id: prevMouse; anchors.fill: parent; hoverEnabled: true; onClicked: sysCalendar.prevMonth() }
        }

        Rectangle {
            width: 26; height: 26
            radius: 6
            color: nextMouse.containsMouse ? "#33ffffff" : "transparent"
            Text { anchors.centerIn: parent; text: "❯"; color: "#ffffff"; font.pixelSize: 12 }
            MouseArea { id: nextMouse; anchors.fill: parent; hoverEnabled: true; onClicked: sysCalendar.nextMonth() }
        }

        Rectangle {
            width: 26; height: 26
            radius: 6
            color: closeMouse.containsMouse ? "#f38ba8" : "transparent"
            Text { anchors.centerIn: parent; text: "✕"; color: closeMouse.containsMouse ? "#11111b" : "#ffffff"; font.pixelSize: 14; font.bold: true }
            MouseArea { id: closeMouse; anchors.fill: parent; hoverEnabled: true; onClicked: root.closeClicked() }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        Repeater {
            model: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
            delegate: Text {
                text: modelData
                color: "#98a696"
                font.pixelSize: 12
                font.bold: true
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

                    color: modelData.isToday ? "#719169" : (dayMouse.containsMouse ? "#22ffffff" : "transparent")
                    border.color: modelData.isToday ? "#ffffff" : "transparent"
                    border.width: modelData.isToday ? 1 : 0

                    Text {
                        anchors.centerIn: parent
                        text: modelData.dayNumber
                        font.pixelSize: 14
                        font.bold: true
                        color: modelData.isToday ? "#0d120d" : (modelData.isCurrentMonth ? "#e6edf3" : "#6c7086")
                    }

                    MouseArea {
                        id: dayMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: console.log("clicked: " + modelData.dateString)
                    }
                }
            }
        }
    }
}