import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "qrc:/config/basic"

BusyIndicator {
    id: control
    running: false
    parent: Window.contentItem
    anchors {
        top: parent.top
        topMargin: Config.titleBarHeight
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }
    property int fontPixel: 20
    property int btnFontPixel: 16
    property bool showClose: false
    property int bgWidth: 300
    property int bgHeight: 100

    contentItem: Rectangle {
        id: root
        color: "#e0646464"
        visible: control.running

        BMRectangle {
            id: loadingBg
            anchors.centerIn: parent
            width: bgWidth
            height: bgHeight

            Column {
                anchors.centerIn: parent
                spacing: 10

                Item {
                    id: loadingRecMask
                    width: loadingBg.width * 0.8
                    height: 5
                    clip: true

                    Rectangle {
                        id: loadingRec
                        width: parent.width
                        height: parent.height
                        radius: height
                        color: Config.themeColor
                        x: -width
                    }
                }

                BMText {
                    id: loadingText
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "加载中..."
                    font.pixelSize: fontPixel
                }
            }
        }

        PropertyAnimation {
            id: ani
            target: loadingRec
            property: "x"
            to: loadingRec.width
            duration: 1500
            onFinished: {
                ani2.restart()
            }
        }

        PropertyAnimation {
            id: ani2
            target: loadingRec
            property: "x"
            to: loadingRec.width + 100
            duration: 300
            onFinished: {
                loadingRec.x = -loadingRec.width
                ani.restart()
            }
        }

        Rectangle {
            id: closeBtn
            anchors {
                top: loadingBg.bottom
                topMargin: 15
                horizontalCenter: parent.horizontalCenter
            }

            width: 110
            height: 35
            radius: 8
            color: "#ea4132"
            visible: showClose

            BMText {
                id: cBtnText
                anchors.centerIn: parent
                color: Config.light
                font.pixelSize: btnFontPixel
                text: qsTr("停止")
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                let point = mapToItem(closeBtn, mouseX, mouseY)
                if (closeBtn.contains(Qt.point(point.x, point.y))) {
                    processUpload.stopHexoS()
                    return
                }
            }
        }

        Component.onCompleted: {
            ani.start()
        }
    }

    onShowCloseChanged: {
        if (showClose && running) {
            closeBtn.visible = showClose
        }
    }
}
