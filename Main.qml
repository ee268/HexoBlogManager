import QtQuick
import QtQuick.Controls
import "qrc:/qml/controls"
import "qrc:/config/basic"
import "qrc:/qml/page"
import Qt5Compat.GraphicalEffects

BMWindow {
    id: window
    minimumWidth: 900
    minimumHeight: 700
    maximumWidth: Screen.desktopAvailableWidth
    maximumHeight: Screen.desktopAvailableHeight
    title: qsTr("Blog Manager")
    property bool initFlag: false
    Component.onCompleted: {
        console.log("screen size: ", Screen.width, Screen.height)
        console.log("desktop screen size: ", Screen.desktopAvailableWidth, Screen.desktopAvailableHeight)
    }

    BMMessageBox {
        id: msgBox
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

    // Item {
    //     id: cursorFlw
    //     width: 200
    //     height: 200

    //     Rectangle {
    //         id: sourceRect
    //         anchors.fill: parent
    //         visible: false
    //     }

    //     RadialGradient {
    //         anchors.fill: parent
    //         source: sourceRect
    //         horizontalOffset: 0
    //         verticalOffset: 0
    //         horizontalRadius: Math.max(width, height) / 2
    //         verticalRadius: Math.max(width, height) / 2

    //         gradient: Gradient {
    //             GradientStop { position: 0.0; color: Qt.rgba(255, 255, 255, 15) }
    //             GradientStop { position: 0.8; color: Qt.rgba(255, 255, 255, 0) }
    //             GradientStop { position: 1.0; color: Qt.rgba(255, 255, 255, 0) }
    //         }
    //     }
    // }

    // MouseArea {
    //     anchors {
    //         topMargin: 32
    //         top: parent.top
    //         left: parent.left
    //         right: parent.right
    //         bottom: parent.bottom
    //     }

    //     hoverEnabled: true
    //     onPositionChanged: (mouse) => {
    //         cursorFlw.x = mouse.x - (cursorFlw.width / 2)
    //         cursorFlw.y = mouse.y - (cursorFlw.height / 2) + 23

    //         console.log("Mouse Center Adjusted:", cursorFlw.x, cursorFlw.y)
    //     }
    // }
}
