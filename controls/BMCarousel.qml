import QtQuick
import "qrc:/config/basic"

BMRectangle {
    id: root

    ListModel {
        id: cardModel
        Component.onCompleted: {
            let list = carouselLoader.GetImgList()
            for (let i = 0; i < list.length; i++) {
                cardModel.append(list[i])
            }
        }
    }

    Item {
        anchors {
            left: parent.left
            leftMargin: 5
            rightMargin: 5
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        height: root.height * 0.95
        clip: true

        Item {
            id: cardBg
            anchors.fill: parent
            property real mainCardWidth: width * 0.6
            property real nonMainCardWidth: (width * 0.4) / 4 - 5
            property int mainCardId: 0

            ListView {
                id: cardListView
                anchors.fill: parent

                spacing: 5
                orientation: ListView.Horizontal
                // interactive: false
                model: cardModel
                delegate: BMCard {
                    height: root.height * 0.95
                    width: {
                        if (index == cardBg.mainCardId) {
                            // progressAni.start()
                            return cardBg.mainCardWidth
                        }
                        return cardBg.nonMainCardWidth
                    }

                    source: imgUrl
                    titleTxt: title
                    subTitleTxt: subtitle
                    contentOpacity: index == cardBg.mainCardId ? 1 : 0
                    btnColor: mainColor

                    Rectangle {
                        id: progress
                        visible: index == cardBg.mainCardId ? true : false
                        radius: height
                        width: parent.width * 0.95
                        opacity: 0.6
                        height: 5
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                            bottom: parent.bottom
                            bottomMargin: 5
                        }
                    }

                    PropertyAnimation {
                        id: progressAni
                        target: progress
                        property: "width"
                        to: 0
                        duration: 6000

                        onFinished: {
                            if (index != cardBg.mainCardId) return

                            if (cardBg.mainCardId + 1 >= cardModel.count) {
                                cardBg.mainCardId = 0
                                return
                            }
                            cardBg.mainCardId++
                        }
                    }

                    onWidthChanged: {
                        if (progressAni.running) {
                            progressAni.restart()
                            return
                        }

                        if (width == cardBg.mainCardWidth) {
                            progressAni.start()
                        }
                    }
                }
            }
        }
    }
}
