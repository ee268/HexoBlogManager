import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"

Rectangle {
    id: root
    height: 35
    width: height
    radius: width
    color: Config.themeColor
    property var msgBoxId: null

    ColorImage {
        anchors.centerIn: parent
        source: col.visible ? "qrc:/res/yml_save_btn/closesaveyml.svg"
                            : "qrc:/res/yml_save_btn/ymlsave.svg"
        width: parent.width * 0.6
        height: width
        color: "white"
    }

    Column {
        id: col
        spacing: 10
        y: -root.height * 2 - spacing * 2
        visible: false

        Rectangle {
            height: root.height
            width: height
            radius: width
            color: Config.themeColor

            BMToolTip {
                id: tooltipCf
                text: qsTr("保存hexo配置")
            }

            ColorImage {
                anchors.centerIn: parent
                source: "qrc:/res/yml_save_btn/configymlsave.svg"
                width: parent.width * 0.6
                height: width
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    let isSuccess = globalMgr.saveConfigYml()
                    if (!isSuccess) {
                        msgBoxId.setMsgBox(true, "Error", "保存出错")
                    }

                    msgBoxId.setMsgBox(true, "Success", "保存成功")
                }
                onEntered: {
                    tooltipCf.visible = true
                }
                onExited: {
                    tooltipCf.visible = false
                }
            }
        }

        Rectangle {
            height: root.height
            width: height
            radius: width
            color: Config.themeColor

            BMToolTip {
                id: tooltipTheme
                text: qsTr("保存主题配置")
            }

            ColorImage {
                anchors.centerIn: parent
                source: "qrc:/res/yml_save_btn/themeymlsave.svg"
                width: parent.width * 0.6
                height: width
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    let isSuccess = globalMgr.saveThemeYml()
                    if (!isSuccess) {
                        msgBoxId.setMsgBox(true, "Error", "保存出错")
                    }

                    msgBoxId.setMsgBox(true, "Success", "保存成功")
                }
                onEntered: {
                    tooltipTheme.visible = true
                }
                onExited: {
                    tooltipTheme.visible = false
                }
            }
        }
    }

    BMToolTip {
        id: tooltip
        text: qsTr("保存配置文件")
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            col.visible = !col.visible
        }
        onEntered: {
            tooltip.visible = true
        }
        onExited: {
            tooltip.visible = false
        }
    }
}
