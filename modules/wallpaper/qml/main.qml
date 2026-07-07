import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root
    width: 900
    height: 190
    focus: true

    property variant wallpaperList: wallpaperManager.loadWallpapers()
    property bool isReady: false
    property bool activeIsA: true

    Keys.onLeftPressed: pathView.decrementCurrentIndex()
    Keys.onRightPressed: pathView.incrementCurrentIndex()
    Keys.onEscapePressed: Qt.quit()

    Timer {
        id: focusFixTimer
        interval: 50
        running: false
        repeat: false
        onTriggered: {
            const activeIndex = wallpaperManager.getCurrentWallpaperIndex(root.wallpaperList)
            pathView.currentIndex = activeIndex
            if (root.wallpaperList.length > 0) {
                backdropA.source = root.wallpaperList[activeIndex]
                backdropA.opacity = 1
                backdropB.opacity = 0
            }
            root.isReady = true
        }
    }

    Component.onCompleted: {
        focusFixTimer.start()
    }

    function crossfadeTo(path) {
        if (activeIsA) {
            backdropB.source = path
            backdropB.opacity = 1
            backdropA.opacity = 0
        } else {
            backdropA.source = path
            backdropA.opacity = 1
            backdropB.opacity = 0
        }
        activeIsA = !activeIsA
    }

    Rectangle {
        id: bgCard
        anchors.fill: parent
        radius: 20
        color: Qt.rgba(0.03, 0.05, 0.04, 0.94)
        border.color: Qt.rgba(0.71, 0.91, 0.69, 0.2)
        border.width: 1
        clip: true

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.55)
            shadowBlur: 0.7
            shadowVerticalOffset: 5
        }

        Item {
            id: backdropLayer
            anchors.fill: parent

            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: 64
            }

            Image {
                id: backdropA
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                opacity: 0
                Behavior on opacity { NumberAnimation { duration: 450; easing.type: Easing.OutQuad } }
            }

            Image {
                id: backdropB
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                opacity: 0
                Behavior on opacity { NumberAnimation { duration: 450; easing.type: Easing.OutQuad } }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0.02, 0.03, 0.02, 0.6)
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.height * 0.5
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(0.71, 0.91, 0.69, 0.08) }
            }
        }

        PathView {
            id: pathView
            anchors.fill: parent
            anchors.topMargin: 18
            anchors.bottomMargin: 36
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            clip: true
            focus: true
            model: root.wallpaperList
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            highlightRangeMode: PathView.StrictlyEnforceRange
            highlightMoveDuration: 200

            delegate: Item {
                width: 160
                height: 120
                property string filePathData: modelData
                scale: PathView.itemScale
                z: PathView.itemZ

                Rectangle {
                    visible: index === pathView.currentIndex
                    anchors.centerIn: parent
                    width: 172
                    height: 132
                    radius: 14
                    color: "transparent"
                    border.color: Qt.rgba(0.71, 0.91, 0.69, 0.55)
                    border.width: 6

                    layer.enabled: true
                    layer.effect: MultiEffect {
                        blurEnabled: true
                        blur: 0.6
                        blurMax: 24
                    }
                }

                Rectangle {
                    width: 160
                    height: 120
                    anchors.centerIn: parent
                    radius: 12
                    color: Qt.rgba(0, 0, 0, 0.3)

                    property color highlightColor: index === pathView.currentIndex
                        ? Qt.rgba(0.71, 0.91, 0.69, 0.85)
                        : Qt.rgba(1, 1, 1, 0.1)

                    border.color: highlightColor
                    border.width: index === pathView.currentIndex ? 2 : 1
                    clip: true

                    Behavior on highlightColor {
                        ColorAnimation { duration: 200 }
                    }

                    Image {
                        anchors.fill: parent
                        source: modelData
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: pathView.currentIndex = index
                    }
                }
            }

            path: Path {
                startX: -60; startY: 60
                PathAttribute { name: "itemScale"; value: 0.75 }
                PathAttribute { name: "itemZ"; value: 1 }
                PathLine { x: 435; y: 60 }
                PathPercent { value: 0.5 }
                PathAttribute { name: "itemScale"; value: 1.1 }
                PathAttribute { name: "itemZ"; value: 10 }
                PathLine { x: 930; y: 60 }
                PathPercent { value: 1.0 }
                PathAttribute { name: "itemScale"; value: 0.75 }
                PathAttribute { name: "itemZ"; value: 1 }
            }

            onCurrentIndexChanged: {
                if (root.isReady && count > 0 && currentItem) {
                    wallpaperManager.setWallpaper(currentItem.filePathData)
                    root.crossfadeTo(currentItem.filePathData)
                }
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 70
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Qt.rgba(0.02, 0.03, 0.02, 0.85) }
                GradientStop { position: 1.0; color: Qt.rgba(0.02, 0.03, 0.02, 0) }
            }
        }
        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 70
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: Qt.rgba(0.02, 0.03, 0.02, 0) }
                GradientStop { position: 1.0; color: Qt.rgba(0.02, 0.03, 0.02, 0.85) }
            }
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.horizontalCenter: parent.horizontalCenter
            width: captionText.width + 24
            height: 24
            radius: 12
            color: Qt.rgba(0, 0, 0, 0.4)
            border.color: Qt.rgba(0.71, 0.91, 0.69, 0.25)
            border.width: 1

            Text {
                id: captionText
                anchors.centerIn: parent
                text: pathView.count > 0
                    ? (pathView.currentIndex + 1) + " / " + pathView.count
                    : ""
                color: "#b5e8b0"
                font.pixelSize: 11
                font.bold: true
                font.family: "JetBrainsMono Nerd Font"
            }
        }
    }
}