import QtQuick
import QtQuick.Controls
import QtWebEngine
import "qrc:/config/basic"

BMWindow {
    minimumWidth: 800
    minimumHeight: 550
    maximumWidth: Screen.desktopAvailableWidth
    maximumHeight: Screen.desktopAvailableHeight
    title: "test"
    isChild: true
    property int loadIdx: -1
    property bool isPLoaded: false
    property bool isCLoaded: false

    BMMessageBox {
        id: msgBox
    }

    BMLoading {
        id: loading
        running: false
        z: 99
    }

    Item {
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

        Rectangle {
            id: btnRec
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: 40
            color: "transparent"

            Rectangle {
                id: saveBtn
                anchors {
                    left: parent.left
                    leftMargin: 5
                    verticalCenter: parent.verticalCenter
                }

                height: parent.height - 10
                width: 80
                radius: 2
                color: Config.themeColor

                BMText {
                    anchors.centerIn: parent
                    font.pixelSize: 16
                    text: "保存"
                    color: Config.light
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        saveBtn.opacity = 0.8
                    }

                    onReleased: {
                        saveBtn.opacity = 1
                        let isSuccess = blogMgr.savePost(loadIdx, textArea.text)
                        if (isSuccess) {
                            msgBox.setMsgBox(true, "Success", "保存成功")
                            return
                        }
                        msgBox.setMsgBox(true, "Success", "保存失败")
                    }
                }
            }
        }

        Rectangle {
            id: editRec
            width: parent.width / 2 - 7.5
            anchors {
                left: parent.left
                top: btnRec.bottom
                bottom: parent.bottom
            }
            radius: 4
            border.width: 1
            border.color: "#a0dbdbdb"
            color: "transparent"

            ScrollView {
                anchors.fill: parent

                TextArea {
                    id: textArea
                    background: Item {}
                    wrapMode: Text.Wrap
                    selectByMouse: true
                    color: Config.isLightMode ? Config.dark : Config.light
                    font.family: "Monospace"
                    font.pixelSize: 16
                    text: loadIdx >= 0 ? blogMgr.getPostContent(loadIdx) : ""

                    onTextChanged: {
                        webView.updateContent(text)
                    }
                }
            }
        }

        Rectangle {
            id: previewRec
            width: parent.width / 2 - 7.5
            anchors {
                right: parent.right
                top: btnRec.bottom
                bottom: parent.bottom
            }
            radius: 4
            border.width: 1
            border.color: "#a0dbdbdb"
            color: "transparent"

            // 部分AI生成
            WebEngineView {
                id: webView
                anchors.fill: parent
                url: "qrc:/qml/controls/html/index.html" // 加载创建的模版

                // 当页面加载完成后，注入 Markdown 内容
                onLoadingChanged: (loadRequest) => {
                    if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                        loadContent();
                    } else if (loadRequest.status === WebEngineView.LoadFailedStatus) {
                        console.error("html load failed:", loadRequest.errorCode, "error:", loadRequest.errorString);
                    }
                }

                //禁止跳转
                onNavigationRequested: (request) => {
                    if (request.navigationType === WebEngineNavigationRequest.LinkClicked) {
                        request.reject()
                    } else {
                        if (url === request.url) {
                            request.accept()
                            return
                        }
                        request.reject()
                    }
                }

                function loadContent() {
                    if (!isPLoaded) isPLoaded = true

                    loadIdx = Config.openPostIdx
                    let rawMarkdown = blogMgr.getPostContent(loadIdx);

                    // 将 Markdown 字符串转义，防止破坏 JS 语法
                    let escapedMd = JSON.stringify(rawMarkdown);

                    // 执行网页内部的渲染函数
                    runJavaScript(`renderMarkdown(${escapedMd})`);
                }

                function updateContent(content) {
                    if (!isCLoaded) isCLoaded = true

                    // 将 Markdown 字符串转义，防止破坏 JS 语法
                    let escapedMd = JSON.stringify(content);

                    // 执行网页内部的渲染函数
                    runJavaScript(`renderMarkdown(${escapedMd})`);
                }
            }
        }
    }

    function closeLoading() {
        if (isCLoaded && isPLoaded) {
            loading.running = false
        }
    }

    onIsCLoadedChanged: {
        closeLoading()
    }
    onIsPLoadedChanged: {
        closeLoading()
    }

    Component.onCompleted: {
        loading.running = true
    }
}
