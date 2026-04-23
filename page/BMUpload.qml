import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"
import "qrc:/qml/controls"

Item {
    anchors.fill: parent
    opacity: 0
    visible: false

    BMLoading {
        id: loading
        running: false
        z: 99
    }

    BMMessageBox {
        id: msgBox
    }

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
                            duration: 100
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
                        cursorShape: Qt.PointingHandCursor
                        onPressed: {
                            btnRec.color = Config.themeColor
                        }
                        onReleased: {
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

                            loading.running = true
                        }
                    }
                }
            }
        }

        Connections {
            target: processUpload
            function onSigFinishedCommand(isSuccess) {
                loading.running = false
                if (isSuccess) {
                    msgBox.setMsgBox(true, "Success", "执行成功")
                }
                else {
                    msgBox.setMsgBox(true, "Error", "执行失败")
                }
            }
            function onSigSendOutput(output) {
                textArea.append(output)
            }
            function onSigStartServer() {
                loading.showClose = true
            }
            function onSigStopServer() {
                loading.running = false
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
            border.color: Config.isLightMode ? "#e0dbdbdb" : "#10ffffff"
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
                    color: Config.isLightMode ? Config.dark : Config.light
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
