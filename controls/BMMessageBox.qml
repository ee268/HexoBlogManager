import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "qrc:/config/basic/"

Popup {
    id: root
    parent: Window.contentItem
    property int boxWidth: 460
    property int boxHeight: 260
    width: boxWidth
    height: boxHeight
    anchors.centerIn: parent
    modal: true
    focus: true
    closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
    padding: 0
    z: 999

    property string msgBoxType: "Info"
    property string msgBoxContent: ""

    function setMsgBox(isShow, type, content) {
        msgBoxType = type
        msgBoxContent = content
        if (isShow) {
            open()
        }
        else {
            close()
        }
    }



    background: Item {}

    Overlay.modal: Rectangle {
        color: "#e0646464"
    }

    contentItem: Rectangle {
        id: boxRec
        anchors.fill: parent
        radius: 7
        color: Config.isLightMode ? Config.light : Config.dark
        layer.enabled: true
        layer.effect: OpacityMask {
            source: boxRec
            maskSource: Rectangle {
                width: boxRec.width
                height: boxRec.height
                radius: boxRec.radius
            }
        }

            Item {
                id: boxTitle
                width: parent.width
                height: 30
                anchors.top: parent.top

                BMText {
                    anchors {
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: {
                        switch(msgBoxType) {
                        case "Info":
                            return "信息"
                        case "Success":
                            return "成功"
                        case "Error":
                            return "错误"
                        case "Warning":
                            return "警告"
                        default:
                            return "msgBoxTitle"
                        }
                    }

                    font.pixelSize: 18
                }

                BMTitleButton {
                    id: closeButton
                    anchors.right: parent.right
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
                }
            }

            Item {
                anchors {
                    top: boxTitle.bottom
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                Column {
                    id: boxCol
                    anchors.centerIn: parent
                    spacing: 15

                    Item {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 100

                        Image {
                            source: {
                                switch(msgBoxType) {
                                case "Info":
                                    return "qrc:/res/msgBox/info.png"
                                case "Success":
                                    return "qrc:/res/msgBox/success.png"
                                case "Error":
                                    return "qrc:/res/msgBox/error.png"
                                case "Warning":
                                    return "qrc:/res/msgBox/warning.png"
                                default:
                                    return "qrc:/res/cover/default.jpg"
                                }
                            }
                            width: parent.width
                            height: parent.height
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    BMText {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: msgBoxContent
                        font.pixelSize: 20
                    }
                }

                Rectangle {
                    id: progress
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 10
                        horizontalCenter: parent.horizontalCenter
                    }
                    height: 7
                    width: parent.width - 20
                    radius: height
                    color: "#27bf73"
                }

                NumberAnimation {
                    id: pgsAni
                    target: progress
                    property: "width"
                    to: 0
                    duration: 5000
                    onFinished: {
                        if (!root.visible) return
                        root.close()
                    }
                }
            }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                let point = mapToItem(closeButton, mouseX, mouseY)
                if (closeButton.contains(Qt.point(point.x, point.y))) {
                    root.close()
                    console.log("close msgBox")
                    return
                }
            }
        }
    }

    onOpened: {
        progress.width = boxRec.width - 20
        pgsAni.restart()
    }
}
