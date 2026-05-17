import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"
import "qrc:/qml/controls"

ScrollView {
    id: root
    anchors.fill: parent
    visible: false
    opacity: 0

    ScrollBar.vertical: BMVScrollBar{
        height: root.height
        anchors.right: root.right
    }

    Column {
        id: contentCol
        spacing: Config.windowDistance

        BMCarousel {
            id: carousel
            width: root.width
            height: root.height * 0.4
        }

        Row {
            spacing: Config.windowDistance

            BMContributionMap {
                id: contriMap
                width: root.width * 0.6
                visible: processImport.readHistory().length > 0

                BMText {
                    anchors.centerIn: parent
                    visible: !contriMap.visible
                    text: qsTr("请先导入配置")
                    font.pixelSize: 30
                }
            }

            BMAvatarCard {
                height: contriMap.height
                width: root.width * 0.4 - Config.windowDistance
                visible: processImport.readHistory().length > 0

                BMText {
                    anchors.centerIn: parent
                    visible: !contriMap.visible
                    text: qsTr("请先导入配置")
                    font.pixelSize: 30
                }
            }
        }

        Row {
            spacing: Config.windowDistance

            BMYmlEditor {
                width: root.width / 2
                height: root.height * 0.8
                text: globalMgr.getConfigYmlContent()
                textChangedEvent: () => {
                    globalMgr.setConfigYmlContent(text)
                }
            }

            BMYmlEditor {
                width: root.width / 2 - parent.spacing
                height: root.height * 0.8
                text: globalMgr.getThemeConfigYmlContent()
                textChangedEvent: () => {
                    globalMgr.setThemeYmlContent(text)
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
    }
}
