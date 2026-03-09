import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "qrc:/config/basic"
import "qrc:/qml/controls"

BMRectangle {
    id: root
    anchors.fill: parent
    color: Config.isLightMode ? Config.light : "#8a8a8a"
    layer.enabled: true
    layer.effect: OpacityMask {
        source: root
        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: root.radius
        }
    }
    visible: false
    opacity: 0


    Behavior on color {
        ColorAnimation {
            duration: Config.aniDuration
        }
    }

    property real imgHeight: 400
    property real imgWidth : 150

    ListModel {
        id: model
        Component.onCompleted: {
            for (let i = 0; i < 10; i++) {
                model.append({ data: i })
            }
        }
    }

    ListModel {
        id: model2
        Component.onCompleted: {
            for (let i = 0; i < 10; i++) {
                model2.append({ data: i })
            }
        }
    }

    ListModel {
        id: model3
        Component.onCompleted: {
            for (let i = 0; i < 10; i++) {
                model3.append({ data: i })
            }
        }
    }

    Item {
        width: parent.width * 0.95
        height: parent.height * 0.95
        anchors.centerIn: parent
        clip: true

        Item {
            id: clipItem
            height: root.height * 2
            width: root.width * 2
            anchors.centerIn: parent
            // anchors.fill: parent
            clip: true
            rotation: -45

            Timer {
                id: timer
                interval: 1000
                repeat: true
                running: true
                onTriggered: {
                    // console.log("timer triggered")
                    behavior.enabled = false
                    model.remove(0)
                    model.append({ data: 1 })
                    behavior.enabled = true
                    view1.contentY += imgHeight * 0.7 + view1.spacing
                }
            }

            Timer {
                id: timer2
                interval: 1000
                repeat: true
                running: true
                onTriggered: {
                    // console.log("timer triggered")
                    behavior2.enabled = false
                    model2.remove(0)
                    model2.append({ data: 1 })
                    behavior2.enabled = true
                    view2.contentY += imgHeight * 0.7 + view1.spacing
                }
            }

            Timer {
                id: timer3
                interval: 1000
                repeat: true
                running: true
                onTriggered: {
                    // console.log("timer triggered")
                    behavior3.enabled = false
                    model3.remove(0)
                    model3.append({ data: 1 })
                    behavior3.enabled = true
                    view3.contentY += imgHeight * 0.7 + view3.spacing
                }
            }

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 50

                Item {
                    height: clipItem.height
                    width: imgWidth
                    rotation: 180

                    ListView {
                        id: view1
                        anchors.fill: parent
                        model: model
                        spacing: 8

                        delegate: Rectangle {
                            id: rect1
                            height: imgHeight
                            width: imgWidth
                            radius: 6
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                source: rect1
                                maskSource: Rectangle {
                                    width: rect1.width
                                    height: rect1.height
                                    radius: rect1.radius
                                }
                            }

                            Image {
                                anchors.fill: parent
                                source: "qrc:/res/about/neko.png"
                                fillMode: Image.PreserveAspectCrop
                            }
                        }

                        Behavior on contentY {
                            id: behavior
                            enabled: true
                            NumberAnimation {
                                duration: 1000
                                onFinished: {
                                    console.log("roll finished")
                                }
                            }
                        }
                    }
                }

                Item {
                    height: clipItem.height
                    width: imgWidth

                    ListView {
                        id: view2
                        anchors.fill: parent
                        model: model2
                        spacing: 8
                        delegate: Rectangle {
                            id: rect2
                            height: imgHeight
                            width: imgWidth
                            radius: 6
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                source: rect2
                                maskSource: Rectangle {
                                    width: rect2.width
                                    height: rect2.height
                                    radius: rect2.radius
                                }
                            }

                            Image {
                                anchors.fill: parent
                                source: "qrc:/res/about/neko.png"
                                fillMode: Image.PreserveAspectCrop
                            }
                        }

                        Behavior on contentY {
                            id: behavior2
                            enabled: true
                            NumberAnimation {
                                duration: 1000
                                onFinished: {
                                    console.log("roll finished")
                                }
                            }
                        }
                    }
                }

                Item {
                    height: clipItem.height
                    width: imgWidth
                    rotation: 180

                    ListView {
                        id: view3
                        anchors.fill: parent
                        model: model3
                        spacing: 8
                        delegate: Rectangle {
                            id: rect3
                            height: imgHeight
                            width: imgWidth
                            radius: 6
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                source: rect3
                                maskSource: Rectangle {
                                    width: rect3.width
                                    height: rect3.height
                                    radius: rect3.radius
                                }
                            }

                            Image {
                                anchors.fill: parent
                                source: "qrc:/res/about/neko.png"
                                fillMode: Image.PreserveAspectCrop
                            }
                        }

                        Behavior on contentY {
                            id: behavior3
                            enabled: true
                            NumberAnimation {
                                duration: 1000
                                onFinished: {
                                    console.log("roll finished")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: recColor
        anchors.fill: parent
        color: "#88000000"

        Rectangle {
            id: circle
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: 80
            }

            width: 150
            height: width
            radius: width
            layer.enabled: true
            layer.effect: OpacityMask {
                source: circle
                maskSource: Rectangle {
                    width: circle.width
                    height: circle.height
                    radius: circle.radius
                }
            }

            Image {
                anchors.fill: parent
                source: "qrc:/res/about/avatar.jpg"
                fillMode: Image.PreserveAspectCrop
            }
        }

        ListModel {
            id: linkModel
            ListElement {
                icon: "qrc:/res/about/neko_round.jpg"
                txt: "博客："
                url: "https://ee268.github.io/"
            }
            ListElement {
                icon: "qrc:/res/about/GitHub_Invertocat_White.svg"
                txt: "仓库地址："
                url: "https://github.com/ee268/HexoBlogManager"
            }
            ListElement {
                icon: "qrc:/res/about/bilibili.svg"
                txt: "bilibili："
                url: "https://space.bilibili.com/280055906"
            }
        }

        Column {
            anchors {
                top: circle.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            spacing: 2

            Repeater {
                model: linkModel
                delegate: Row {
                    spacing: 10
                    Item {
                        width: 30
                        height: 30
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.fill: parent
                            source: icon
                            fillMode: Image.PreserveAspectCrop
                        }
                    }

                    BMText {
                        id: bmTxt
                        anchors.verticalCenter: parent.verticalCenter
                        text: txt + url
                        font.pixelSize: 20
                        color: Config.light
                        runRainbow: true

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {
                                bmTxt.pauseRainbow()
                            }
                            onExited: {
                                bmTxt.resumeRainbow()
                            }
                            onClicked: {
                                Qt.openUrlExternally(url)
                            }
                        }
                    }
                }
            }
        }

        BMText {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 20
            }

            text: "Designed by ee268 | 2026"
            font.pixelSize: 20
            color: Config.light
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: Config.aniDuration
        }
    }

    Component.onCompleted: {
        visible = true
        opacity = 1
    }
}
