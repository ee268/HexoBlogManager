import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"
import "qrc:/qml/controls"

Item {
    anchors.fill: parent
    opacity: 0
    visible: false

    Behavior on opacity {
        NumberAnimation {
            duration: Config.aniDuration
        }
    }

    BMRectangle {
        id: topRec
        width: parent.width
        height: parent.height * 0.4

        ListModel {
            id: cmdList
            ListElement {
                name: "部署"
                pgm: "hexo d"
            }
            ListElement {
                name: "生成并部署"
                pgm: "hexo g;hexo d"
            }
            ListElement {
                name: "清理"
                pgm: "hexo clean"
            }
        }

        ListModel {
            id: cmdList2
            ListElement {
                name: "生成"
                pgm: "hexo g"
            }
            ListElement {
                name: "预览"
                pgm: "hexo s"
            }
            ListElement {
                name: "生成并预览"
                pgm: "hexo g;hexo s"
            }
        }

        Row {
            anchors.centerIn: parent
            spacing: 10
            Column {
                spacing: 10
                Repeater {
                    model: cmdList
                    delegate: cmdBtn
                }
            }
            Column {
                spacing: 10
                Repeater {
                    model: cmdList2
                    delegate: cmdBtn
                }
            }
        }

        Component {
            id: cmdBtn
            Item {
                id: btnItem
                width: 300
                height: 50

                Rectangle {
                    id: btnRec
                    anchors.fill: parent
                    color: "transparent"
                    border.width: 2
                    border.color: Config.themeColor
                    radius: 7

                    Behavior on color {
                        ColorAnimation {
                            duration: Config.aniDuration
                        }
                    }

                    BMText {
                        anchors.centerIn: parent
                        text: name
                        font.pixelSize: 20
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            btnRec.color = Config.themeColor
                        }
                        onExited: {
                            btnRec.color = "transparent"
                        }

                        onClicked: {
                            textArea.clear()
                            let arguments = pgm.split(";")
                            // console.log(arguments);
                            for (let i = 0; i < arguments.length; i++) {
                                let splitArg = arguments[i].split(" ")
                                // console.log("excute command: ", arguments[i])
                                processUpload.addCommand(splitArg[0], splitArg[1])
                            }

                            Config.isLoading = true
                        }
                    }
                }
            }
        }

        Connections {
            target: processUpload
            function onSigFinishedCommand(isSuccess) {
                Config.isLoading = false
            }
            function onSigSendOutput(output) {
                textArea.append(output)
            }
            function onSigStartServer() {
                Config.loadingText = "预览中"
                Config.loadingCancelBtn = true
            }
            function onSigStopServer() {
                Config.isLoading = false
                Config.loadingText = qsTr("加载中")
                Config.loadingCancelBtn = false
            }
        }
    }

    BMRectangle {
        id: bottomRec
        anchors {
            top: topRec.bottom
            topMargin: Config.windowDistance
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Rectangle {
            width: parent.width - 10
            height: parent.height - 10
            anchors.centerIn: parent
            color: "transparent"
            border.width: 2
            border.color: "#e0dbdbdb"
            radius: 7

            BMText {
                anchors.centerIn: parent
                text: qsTr("暂无日志")
                color: "gray"
                font.pixelSize: 25
                opacity: 0.6
                visible: textArea.text.length <= 0
            }

            ScrollView {
                anchors.fill: parent

                TextArea {
                    id: textArea
                    readOnly: true
                    background: Item {}
                    wrapMode: Text.Wrap
                    selectByMouse: true
                    font.family: "Monospace"
                    font.pixelSize: 16
                    text: ""
                }
            }
        }
    }

    Component.onCompleted: {
        visible = true
        opacity = 1
    }
}
