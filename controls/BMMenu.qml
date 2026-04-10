import QtQuick
import QtQuick.Controls
import "qrc:/config/basic"

BMRectangle {
    id: root
    width: 60
    visible: false
    opacity: 0

    Behavior on opacity {
        NumberAnimation {
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
                name: "部署"
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
                    ctrlMark.changeBtnColor(true, index, menuRep)
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
                    ctrlMark.changeBtnColor(false, index, menuRep2)
                }
            }
        }
    }

    Connections {
        target: Config
        function onChangeToMenuChanged() {
            console.log("haha")
            if (Config.changeToMenu.length <= 0) return
            if (Config.changeToMenu[0]) {
                ctrlMark.changeBtnColor(true, Config.changeToMenu[1], menuRep)
            }
            else {
                ctrlMark.changeBtnColor(false, Config.changeToMenu[1], menuRep2)
            }
        }
    }

    QtObject {
        id: ctrlMark

        function changeBtnColor(isTop, idx, menuId) {
            let item = null;
            if (Config.lastMenu >= 0) {
                if (!isTop && Config.isTopMenu) {
                    item = menuRep.itemAt(Config.curMenu)
                }
                else if (isTop && !Config.isTopMenu) {
                    item = menuRep2.itemAt(Config.curMenu)
                }
                else {
                    item = menuId.itemAt(Config.curMenu)
                }

                if (item) {
                    item.background = "transparent"
                    item.imgColor = Config.themeColor
                }
                else {
                    console.log("get last item", Config.lastMenu, " failed")
                    return;
                }
            }
            item = menuId.itemAt(idx)

            Config.isTopMenu = isTop
            Config.curMenu = idx

            Config.lastMenu = Config.curMenu
            Config.lastIsTopMenu = Config.isTopMenu

            if (item) {
                item.imgColor = "white"
                item.background = Config.themeColor
                skipToPage(item.pId)
            }
            else {
                console.log("get item", idx, " failed")
                return;
            }
        }

        function skipToPage(pageId) {
            switch (pageId) {
                case "home" :
                    console.log("page change to ", pageId)
                    pageLoader.sourceComponent = home
                    break
                case "blog":
                    console.log("page change to ", pageId)
                    pageLoader.sourceComponent = blog
                    break
                case "imp":
                    console.log("page change to ", pageId)
                    pageLoader.sourceComponent = imp
                    break
                case "upload":
                    console.log("page change to ", pageId)
                    pageLoader.sourceComponent = upload
                    break
                case "about":
                    console.log("page change to ", pageId)
                    pageLoader.sourceComponent = about
                    break
                case "setting":
                    console.log("page change to ", pageId)
                    pageLoader.sourceComponent = setting
                    break
                default:
                    console.log("not found pId:", pageId)
                    break
            }
        }
    }

    Connections {
        target: globalMgr
        function onSigRefreshMenuColor() {
            refreshColor()
        }
    }

    function refreshColor() {
        for (let i = 0; i < topMenuModel.count; i++) {
            let item = menuRep.itemAt(i)
            if (i === Config.curMenu && Config.isTopMenu) {
                item.imgColor = "white"
                item.background = Config.themeColor
                continue
            }
            item.imgColor = Config.themeColor
        }
        for (let i = 0; i < bottomMenuModel.count; i++) {
            let item = menuRep2.itemAt(i)
            if (i === Config.curMenu && !Config.isTopMenu) {
                item.imgColor = "white"
                item.background = Config.themeColor
                continue
            }
            item.imgColor = Config.themeColor
        }
    }

    onHeightChanged: {
        if (!Config.isTopMenu) {
            ctrlMark.changeBtnColor(Config.isTopMenu, Config.curMenu, menuRep2)
        }
    }

    Component.onCompleted: {
        ctrlMark.changeBtnColor(Config.isTopMenu, 0, menuRep)
        visible = true
        opacity = 1
    }
}
