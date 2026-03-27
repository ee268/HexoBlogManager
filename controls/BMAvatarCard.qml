import QtQuick
import Qt5Compat.GraphicalEffects
import "qrc:/config/basic"

BMRectangle {

    Row {
        anchors.centerIn: parent
        spacing: 10
        Rectangle {
            id: round
            width: 100
            height: 100
            radius: width / 2
            color: "transparent"
            border.width: 2
            border.color: Config.themeColor
            z: 1

            Image {
                id: avatarImg
                anchors.fill: parent
                anchors.margins: parent.border.width
                source: "qrc:/res/about/avatar.jpg"
                fillMode: Image.PreserveAspectCrop
                visible: false
            }

            OpacityMask {
                anchors.fill: avatarImg
                source: avatarImg
                maskSource: Rectangle {
                    width: avatarImg.width
                    height: avatarImg.height
                    radius: avatarImg.width / 2
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Qt.openUrlExternally(ymlConfig.getBlogUrl())
                }
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            BMText {
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 20
                text: ymlConfig.getAuthor()
            }

            BMText {
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16
                color: "#a9a9a9"
                opacity: 0.9
                text: ymlConfig.getDesc()
            }
        }
    }
}
