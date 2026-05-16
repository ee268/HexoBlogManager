import QtQuick
import QtQuick.Controls
import Qt.labs.platform
import "qrc:/config/basic"
import "qrc:/qml/controls"

BMRectangle {
    anchors.fill: parent
    opacity: 0
    visible: false

    BMColorDialog { id: colorDlg }

    Item {
        width: parent.width - 40
        height: parent.height - 40
        anchors.centerIn: parent

        Column {
            spacing: 20

            BMSwitch {
                id: darkModeSwitch
                text: qsTr("夜间模式是否跟随系统")
                font.pixelSize: 20

                onCheckedChanged: {
                    // console.log(checked)
                    globalMgr.setValue("isAutoMode", checked)
                    if (checked) {
                        Config.isAutoMode = checked
                        return
                    }

                    Config.isAutoMode = false
                    Config.isLightMode = true
                }
            }

            Row {
                spacing: 7
                BMText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("更改主题颜色")
                    font.pixelSize: 20
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 27
                    height: width
                    radius: 3
                    color: Config.themeColor

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            colorDlg.open()
                        }
                    }
                }
            }

            Row {
                spacing: 7

                BMText {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("主题配置文件路径")
                    font.pixelSize: 20
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    id: textInputBg
                    radius: 10
                    height: 30
                    width: 300
                    color: "transparent"
                    border.width: 2
                    border.color: Config.themeColor

                    TextInput {
                        id: textInput
                        text: ""
                        anchors.centerIn: parent
                        width: parent.width - 16
                        height: parent.height - 10
                        color: Config.isLightMode ? Config.dark : Config.light
                        verticalAlignment: Text.AlignVCenter
                        clip: true
                        onEditingFinished: {
                            globalMgr.setValue("themeConfigYml", "file:///" + text)
                            processImport.setThemeConfigYml(text)
                        }
                    }
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    height: textInputBg.height
                    width: 60
                    color: Config.themeColor
                    radius: textInputBg.radius
                    BMText {
                        anchors.centerIn: parent
                        text: qsTr("打开")
                        font.pixelSize: 20
                    }

                    FileDialog {
                        id: folderDlg
                        acceptLabel: qsTr("导入")
                        rejectLabel: qsTr("取消")
                        fileMode: FileDialog.OpenFile
                        nameFilters: ["Yaml files (*.yml *yaml)"]

                        onAccepted: {
                            console.log(currentFile)
                            globalMgr.setValue("themeConfigYml", currentFile.toString())
                            processImport.setThemeConfigYml(currentFile.toString())
                            textInput.text = currentFile.toString().slice(8)
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            folderDlg.open()
                        }
                    }
                }
            }
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
        if (globalMgr.contains("isAutoMode")) {
            darkModeSwitch.checked = globalMgr.getValue("isAutoMode")
        }

        if (globalMgr.contains("themeConfigYml")) {
            let path = globalMgr.getValue("themeConfigYml")
            textInput.text = path.slice(8)
        }
    }
}
