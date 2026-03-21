import QtQuick
import QtQuick.Window
import QtQuick.Controls
import Qt.labs.platform
import Qt5Compat.GraphicalEffects
import "qrc:/config/basic"

Window {
    id: window
    color: "transparent"
    visible: true
    flags: Qt.FramelessWindowHint | Qt.Window
    property bool isChild: false

    Rectangle {
        id: windowBg
        anchors.fill: parent
        color: Config.isLightMode ? Config.light : Config.dark
        radius: 8
        clip: true
        border.width: 1
        border.color: "#f03d444d"
        layer.enabled: true
        layer.effect: OpacityMask {
            source: windowBg
            maskSource: Rectangle {
                width: windowBg.width
                height: windowBg.height
                radius: windowBg.radius
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: Config.aniDuration
            }
        }

        //标题栏
        Rectangle {
            id: titleBar
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: Config.titleBarHeight
            color: "transparent"

            BMText {
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: window.title
                font.pixelSize: 14
            }

            Row {
                id: btnRow
                anchors {
                    top: parent.top
                    right: parent.right
                }
                height: parent.height

                BMTitleButton {
                    id: styleChanged
                    height: parent.height
                    source: Config.isLightMode ? "qrc:/res/title_bar/light.svg" : "qrc:/res/title_bar/dark.svg"
                    imgHeight: minButton.imgHeight + 5
                    imgWidth: minButton.imgWidth + 5
                    visible: !isChild
                    onClicked: {
                        Config.isLightMode = !Config.isLightMode

                        console.log("isLightMode ", Config.isLightMode)
                    }
                    // Component.onCompleted: windowAgent.setHitTestVisible(styleChanged, true)
                }

                BMTitleButton {
                    id: minButton
                    height: parent.height
                    source: "qrc:/res/title_bar/minimize.svg"
                    onClicked: window.showMinimized()
                    // Component.onCompleted: windowAgent.setSystemButton(WindowAgent.Minimize, minButton)
                }

                BMTitleButton {
                    id: maxButton
                    height: parent.height
                    source: window.visibility === Window.Maximized ? "qrc:/res/title_bar/restore.svg" : "qrc:/res/title_bar/maximize.svg"
                    onClicked: {
                        if (window.visibility === Window.Maximized) {
                            window.showNormal()
                        } else {
                            window.showMaximized()
                        }
                    }
                    // Component.onCompleted: windowAgent.setSystemButton(WindowAgent.Maximize, maxButton)
                }

                BMTitleButton {
                    id: closeButton
                    height: parent.height
                    source: "qrc:/res/title_bar/close.svg"
                    background: Rectangle {
                        color: {
                            if (!closeButton.enabled) {
                                return "gray";
                            }
                            if (closeButton.pressed) {
                                return "#e81123";
                            }
                            if (closeButton.hovered) {
                                return "#e81123";
                            }
                            return "transparent";
                        }
                    }
                    onClicked: window.close()
                    // Component.onCompleted: windowAgent.setSystemButton(WindowAgent.Close, closeButton)
                }
            }

            MouseArea {
                anchors {
                    left: parent.left
                    right: btnRow.left
                    top: parent.top
                    bottom: parent.bottom
                }

                property point clickPos: "0, 0"
                onPressed: (mouse) => {
                    clickPos = Qt.point(mouse.x, mouse.y)
                    // console.log(clickPos)
                }

                onPositionChanged: (mouse) => {
                    // console.log("window: ", window.x, window.y)
                    //计算鼠标当前位置和点击位置的差值
                    let delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)

                    //将当前窗口所在屏幕的位置移动delta
                    window.x += delta.x
                    window.y += delta.y
                }
            }
        }
    }

    BMWindowDragArea {
        anchors.fill: parent
        window: window
    }
}
