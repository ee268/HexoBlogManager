import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"
import "qrc:/qml/controls"
import Qt5Compat.GraphicalEffects

BMRectangle {
    anchors.fill: parent
    opacity: 0
    visible: false

    Behavior on opacity {
        NumberAnimation {
            duration: Config.aniDuration
        }
    }

    ListModel {
        id: blogList
        Component.onCompleted: {
            let json = blogMgr.getBlogInfo()
            for (let i = 0; i < json.length; i++) {
                blogList.append(json[i])
            }
        }
    }

    BMText {
        id: title
        anchors {
            top: parent.top
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }

        text: "博文"
        font.pixelSize: 25
    }

    Item {
        id: listItem
        width: parent.width - 14
        anchors {
            top: title.bottom
            topMargin: 8
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        ListView {
            id: listView
            anchors.fill: parent
            clip: true
            spacing: 8
            model: blogList

            ScrollBar.vertical: ScrollBar {
                anchors.right: parent.right
                width: 7
                contentItem: Rectangle {
                    implicitWidth: 10
                    radius: 4
                    color: Config.isLightMode ? Config.dark : Config.light
                }
            }

            delegate: listViewDelegate
        }
    }

    Component {
        id: listViewDelegate

        Rectangle {
            id: borderRec
            width: listItem.width
            height: 100
            color: "transparent"
            border.width: 1
            border.color: "#e0dbdbdb"
            radius: 6

            Behavior on scale {
                NumberAnimation {
                    duration: 200
                }
            }

            Rectangle {
                id: blogRec
                width: parent.width - 4
                height: parent.height - 4
                anchors.centerIn: parent
                radius: 6
                color: Config.isLightMode ? Config.light : Config.dark
                layer.enabled: true
                layer.effect: OpacityMask {
                    source: blogRec
                    maskSource: Rectangle {
                        width: blogRec.width
                        height: blogRec.height
                        radius: blogRec.radius
                    }
                }

                Rectangle {
                    id: coverRec
                    anchors {
                        left: parent.left
                    }

                    width: parent.width * 0.4
                    height: parent.height
                    Image {
                        id: blogCover
                        anchors.fill: parent
                        source: cover
                        fillMode: Image.PreserveAspectCrop
                        onStatusChanged: {
                            if (status == Image.Error) {
                                source = "qrc:/res/cover/default.jpg"
                            }
                        }
                    }
                }

                Rectangle {
                    y: -((height - parent.height) / 2)
                    x: -(coverRec.width * 0.2)
                    width: parent.width
                    height: parent.height * 2
                    color: Config.isLightMode ? Config.light : Config.dark
                    rotation: -45
                }

                Column {
                    spacing: 10
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: coverRec.right
                    }

                    BMText {
                        text: name
                        font.pixelSize: 20
                        width: blogRec.width - coverRec.width - btnRow.width - 50
                        elide: Text.ElideRight
                    }

                    BMText {
                        text: previewStr
                        font.pixelSize: 18
                        width: blogRec.width - coverRec.width - btnRow.width - 50
                        opacity: 0.5
                        elide: Text.ElideRight
                    }
                }

                Row {
                    id: btnRow
                    anchors {
                        right: parent.right
                        rightMargin: 20
                        verticalCenter: parent.verticalCenter
                    }
                    spacing: 20

                    BMText {
                        font.pixelSize: 17
                        text: date
                    }

                    Item {
                        width: 20
                        height: 20
                        Image {
                            id: editImg
                            width: parent.width
                            height: parent.height
                            fillMode: Image.PreserveAspectCrop
                            source: "qrc:/res/blog/edit.svg"
                            visible: false
                        }
                        ColorOverlay {
                            anchors.fill: editImg
                            source: editImg
                            color: Config.themeColor
                        }
                    }

                    Item {
                        width: 20
                        height: 20
                        Image {
                            id: uploadImg
                            width: parent.width
                            height: parent.height
                            fillMode: Image.PreserveAspectCrop
                            source: "qrc:/res/menu_bar/upload.svg"
                            visible: false
                        }
                        ColorOverlay {
                            anchors.fill: uploadImg
                            source: uploadImg
                            color: Config.themeColor
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    borderRec.scale = 1.05
                }
                onExited: {
                    borderRec.scale = 1
                }
            }
        }
    }

    Component.onCompleted: {
        visible = true
        opacity = 1
    }
}
