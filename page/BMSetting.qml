import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"
import "qrc:/qml/controls"

BMRectangle {
    anchors.fill: parent
    opacity: 0
    visible: false

    Item {
        width: parent.width - 40
        height: parent.height - 40
        anchors.centerIn: parent

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
    }
}
