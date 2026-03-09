import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"

BMRectangle {
    id: root
    width: 60
    color: Config.isLightMode ? Config.light : Config.dark
    visible: false
    opacity: 0

    Behavior on opacity {
        NumberAnimation {
            duration: Config.aniDuration
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: Config.aniDuration
        }
    }

    //顶部菜单
    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: (parent.width - width) / 2
        }
        spacing: (parent.width - width) / 2

        ListModel {
            id: topMenuModel
            ListElement {
                name: "主页"
                pageId: "home"
                img: "qrc:/res/menu_bar/home.svg"
            }

            ListElement {
                name: "博文"
                pageId: "blog"
                img: "qrc:/res/menu_bar/blog.svg"
            }

            ListElement {
                name: "导入"
                pageId: "imp"
                img: "qrc:/res/menu_bar/import.svg"
            }

            ListElement {
                name: "上传"
                pageId: "upload"
                img: "qrc:/res/menu_bar/upload.svg"
            }
        }

        Repeater {
            id: menuRep
            model: topMenuModel
            delegate: BMMenuButton {
                btnWidth: 40
                btnHeight: width
                source: img
                text: name
                pId: pageId
                imgWidth: 29
                imgHeight: 29
                textPxSz: 16
                clickedEvent: () => {
                    // console.log(index)
                    ctrlMark.moveSelectedMark(true, index, menuRep)
                }
            }
        }
    }

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: (parent.width - width) / 2
        }
        spacing: (parent.width - width) / 2

        ListModel {
            id: bottomMenuModel
            ListElement {
                name: "关于"
                pageId: "about"
                img: "qrc:/res/menu_bar/about.svg"
            }

            ListElement {
                name: "设置"
                pageId: "setting"
                img: "qrc:/res/menu_bar/setting.svg"
            }
        }

        Repeater {
            id: menuRep2
            model: bottomMenuModel
            delegate: BMMenuButton {
                btnWidth: 40
                btnHeight: width
                source: img
                text: name
                pId: pageId
                imgWidth: 29
                imgHeight: 29
                textPxSz: 16
                clickedEvent: () => {
                    // console.log(index)
                    ctrlMark.moveSelectedMark(false, index, menuRep2)
                }
            }
        }
    }

    Rectangle {
        id: selectedMark
        width: 40
        height: width
        color: "transparent"
        Behavior on y {
            NumberAnimation {
                duration: Config.aniDuration
            }
        }
    }

    QtObject {
        id: ctrlMark

        property bool isInit: true

        function moveSelectedMark(isTop, idx, menuId) {
            let item = menuId.itemAt(idx)
            Config.isTopMenu = isTop
            Config.curMenu = idx

            if (item) {
                let btnPos = item.mapToItem(selectedMark.parent, 0, 0);
                if (!isInit) {
                    selectedMark.x = btnPos.x
                    selectedMark.y = btnPos.y
                    selectedMark.radius = item.radius
                    selectedMark.border.width = item.bdWidth
                    selectedMark.border.color = Config.themeColor
                    // console.log("button actual pos: ", btnPos.x, btnPos.y)
                    return
                }
                selectedMark.y = btnPos.y
                console.log("selectedMark move to", idx, ", isTop", Config.isTopMenu)

                switch (item.pId) {
                case "home" :
                    console.log("page change to ", item.pId)
                    pageLoader.sourceComponent = home
                    break
                case "blog":
                    console.log("page change to ", item.pId)
                    pageLoader.sourceComponent = blog
                    break
                case "imp":
                    console.log("page change to ", item.pId)
                    pageLoader.sourceComponent = imp
                    break
                case "upload":
                    console.log("page change to ", item.pId)
                    pageLoader.sourceComponent = upload
                    break
                case "about":
                    console.log("page change to ", item.pId)
                    pageLoader.sourceComponent = about
                    break
                case "setting":
                    console.log("page change to ", item.pId)
                    pageLoader.sourceComponent = setting
                    break
                default:
                    console.log("not found pId:", item.pId)
                    break
                }
            }
            else {
                console.log("get item", idx, " failed")
            }
        }
    }

    onHeightChanged: {
        if (!Config.isTopMenu) {
            ctrlMark.moveSelectedMark(Config.isTopMenu, Config.curMenu, menuRep2)
        }
    }

    Component.onCompleted: {
        ctrlMark.isInit = false
        ctrlMark.moveSelectedMark(Config.isTopMenu, 0, menuRep)
        ctrlMark.isInit = true
        visible = true
        opacity = 1
    }
}
