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
    property int textPxSz: 16
    property alias text: txt.text
    property alias radius: btnBg.radius
    property int bdWidth: btnBg.border.width
    property color bdColor: btnBg.border.color
    property var clickedEvent: ()=>{}
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
            Image {
                id: image
                anchors.centerIn: parent
                mipmap: true
                width: 12
                height: 12
                fillMode: Image.PreserveAspectFit
                visible: false
            }

            ColorOverlay {
                anchors.fill: image
                source: image
                color: Config.themeColor
            }
        }

        background: Rectangle {
            id: btnBg
            radius: 6
            border.width: 2
            border.color: "transparent"
            color: "transparent"
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
