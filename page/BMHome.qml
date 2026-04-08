import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"
import "qrc:/qml/controls"

ScrollView {
    id: root
    anchors.fill: parent
    visible: false
    opacity: 0

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
            }

            BMAvatarCard {
                height: contriMap.height
                width: root.width * 0.4 - Config.windowDistance
            }
        }

        Row {
            spacing: Config.windowDistance

            BMYmlTreeView {
                width: root.width / 2
                height: root.height * 0.8
                model: ymlModel
            }
            BMYmlTreeView {
                width: root.width / 2 - parent.spacing
                height: root.height * 0.8
                Component.onCompleted: {
                    if (globalMgr.contains("themeConfigYml")) {
                        processImport.setThemeConfigYml(globalMgr.getValue("themeConfigYml"))
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
    }
}
