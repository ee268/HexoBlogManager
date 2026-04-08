import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"

Switch {
    id: control
    text: qsTr("Switch")
    padding: 0
    spacing: 10

    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 26
        anchors {
            left: control.contentItem.right
            leftMargin: control.spacing
            verticalCenter: control.verticalCenter
        }

        radius: 13
        color: control.checked ? Config.themeColor : (Config.isLightMode ? Config.light : Config.dark)
        border.color: control.checked ? Config.themeColor : "#cccccc"
        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }

        Rectangle {
            x: control.checked ? parent.width - width : 0
            width: 26
            height: 26
            radius: 13
            color: control.down ? "#cccccc" : "#ffffff"
            border.color: control.checked ? Config.themeColor : "#cccccc"
            Behavior on x {
                NumberAnimation {
                    duration: 200
                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                control.checked = !control.checked
            }
            onPressed: control.down = true
            onReleased: control.down = false
        }
    }

    contentItem: BMText {
        text: control.text
        font.pixelSize: parent.font.pixelSize
        opacity: enabled ? 1.0 : 0.3
        verticalAlignment: Text.AlignVCenter

        MouseArea {
            anchors.fill: parent
        }
    }
}

