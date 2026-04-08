import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "qrc:/config/basic"

Column {
    spacing: 3
    property int btnWidth: 40
    property int btnHeight: 40
    property alias source: image.source
    property alias imgHeight: image.height
    property alias imgWidth: image.width
    property alias imgColor: image.color
    property int textPxSz: 16
    property alias text: txt.text
    property var clickedEvent: ()=>{}
    property alias background: btnBg.color
    property string pId: ""

    Button {
        id: btn
        width: btnWidth
        height: btnHeight
        leftPadding: 0
        topPadding: 0
        rightPadding: 0
        bottomPadding: 0
        leftInset: 0
        topInset: 0
        rightInset: 0
        bottomInset: 0

        contentItem: Item {
            ColorImage {
                id: image
                anchors.centerIn: parent
                mipmap: true
                width: 12
                height: 12
                fillMode: Image.PreserveAspectFit
                color: Config.themeColor
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
            }
        }

        background: Rectangle {
            id: btnBg
            radius: 6
            border.width: 2
            border.color: Config.themeColor
            color: "transparent"

            Behavior on color {
                ColorAnimation {
                    duration: 100
                }
            }
        }

        onClicked: {
            clickedEvent()
        }
    }

    BMText {
        id: txt
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: textPxSz
    }
}
