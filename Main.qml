import QtQuick
import QtQuick.Controls
import "qrc:/qml/controls"
import "qrc:/config/basic"
import "qrc:/qml/page"
import Qt5Compat.GraphicalEffects

BMWindow {
    id: window
    minimumWidth: 1000
    minimumHeight: 700
    maximumWidth: Screen.desktopAvailableWidth
    maximumHeight: Screen.desktopAvailableHeight
    title: qsTr("Blog Manager")

    Connections {
        target: themeHelper
        function onColorSchemeChanged(scheme) {
            if (Config.isAutoMode) {
                let colorScheme = themeHelper.colorScheme
                if (colorScheme === themeHelper.V_Dark()) {
                    Config.isLightMode = false
                }
                else if (colorScheme === themeHelper.V_Light()) {
                    Config.isLightMode = true
                }
            }
        }
    }

    //内容区
    Item {
        id: rootContainer
        anchors {
            top: parent.top
            topMargin: Config.titleBarHeight + Config.windowDistance
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: Config.windowDistance
            rightMargin: Config.windowDistance
            bottomMargin: Config.windowDistance
        }

        BMMenu {
            id: menu

            anchors {
                top: parent.top
                left: parent.left
                bottom: parent.bottom
            }
        }

        //页面内容
        Loader {
            id: pageLoader
            anchors {
                left: menu.right
                leftMargin: 20
                top: parent.top
                bottom: parent.bottom
                right: parent.right
            }

            asynchronous: true
            sourceComponent: home
        }

        Component {
            id: home
            BMHome {}
        }

        Component {
            id: blog
            BMBlog {}
        }

        Component {
            id: imp
            BMImport {}
        }

        Component {
            id: upload
            BMUpload {}
        }

        Component {
            id: about
            BMAbout {}
        }

        Component {
            id: setting
            BMSetting {}
        }
    }

    Component.onCompleted: {
        console.log("screen size: ", Screen.width, Screen.height)
        console.log("desktop screen size: ", Screen.desktopAvailableWidth, Screen.desktopAvailableHeight)

        if (globalMgr.contains("isAutoMode")) {
            Config.isAutoMode = globalMgr.getValue("isAutoMode")
        }
        if (globalMgr.contains("themeColor")) {
            Config.themeColor = globalMgr.getValue("themeColor")
        }
    }
}
