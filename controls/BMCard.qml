import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "qrc:/config/basic"

Rectangle {
    id: root
    radius: 12
    height: parent ? parent.height * 0.95 : 0
    width: parent ? parent.height * 0.6 : 0
    layer.enabled: true
    layer.effect: OpacityMask {
        source: root
        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: root.radius
        }
    }

    property alias source: srcImg.source
    property alias titleTxt: title.text
    property alias subTitleTxt: subTitle.text
    property int contentOpacity: 1
    property color btnColor: "pink"
    property var btnClickedEvent: () => {}

    Behavior on width {
        NumberAnimation {
            duration: Config.aniDuration
        }
    }

    Image {
        id: srcImg
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: "qrc:/res/cover/default.jpg"
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#DD353535" }
            GradientStop { position: 1.0; color: "#00ffffff" }
        }
    }

    BMText {
        id: title
        anchors {
            top: parent.top
            topMargin: parent.height * 0.4
            left: parent.left
            leftMargin: 15
        }
        width: parent.width * 0.6 - anchors.leftMargin

        color: "white"
        font.pixelSize: 24
        elide: Text.ElideRight
        opacity: contentOpacity
        Behavior on opacity {
            NumberAnimation {
                duration: Config.aniDuration
            }
        }
    }

    BMText {
        id: subTitle
        anchors {
            left: parent.left
            leftMargin: 15
        }

        width: parent.width - anchors.leftMargin
        y: title.y + title.height + 5
        color: "white"
        font.pixelSize: 15
        elide: Text.ElideRight
        opacity: contentOpacity

        Behavior on opacity {
            NumberAnimation {
                duration: Config.aniDuration
            }
        }
    }

    Button {
        id: linkBtn
        anchors {
            top: subTitle.bottom
            topMargin: 18
            left: parent.left
            leftMargin: 15
        }

        leftPadding: 0
        topPadding: 0
        rightPadding: 0
        bottomPadding: 0
        leftInset: 0
        topInset: 0
        rightInset: 0
        bottomInset: 0
        opacity: contentOpacity

        Behavior on opacity {
            NumberAnimation {
                duration: Config.aniDuration
            }
        }

        contentItem: Item {
            BMText {
                id: btnText
                anchors.centerIn: parent
                color: "white"
                text: qsTr("> 查看详细")
                font.pixelSize: 17
            }
        }

        background: Rectangle {
            id: btnBg
            implicitWidth: 100
            implicitHeight: 33
            radius: 8
            color: btnColor
        }

        onClicked: {
            console.log("clicked linkbtn")
            Qt.openUrlExternally(externalUrl)
        }
    }

    Item {
        id: cursorFlw
        width: 200
        height: 200
        visible: false

        Rectangle {
            id: sourceRect
            anchors.fill: parent
            visible: false
        }

        RadialGradient {
            anchors.fill: parent
            source: sourceRect
            horizontalOffset: 0
            verticalOffset: 0
            horizontalRadius: Math.max(width, height) / 2
            verticalRadius: Math.max(width, height) / 2

            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.1) }
                GradientStop { position: 0.8; color: "transparent" }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onPositionChanged: {
            cursorFlw.visible = true
            if (index == cardBg.mainCardId && progressAni.running) {
                progressAni.pause()
            }

            cursorFlw.x = mouseX - (cursorFlw.width / 2)
            cursorFlw.y = mouseY - (cursorFlw.height / 2) + 23
        }

        onClicked: {
            var btnPoint = mapToItem(linkBtn, mouseX, mouseY)
            if (linkBtn.contains(Qt.point(btnPoint.x, btnPoint.y)) && linkBtn.opacity == 1) {
                linkBtn.clicked() // 手动触发
                return
            }
            cardBg.mainCardId = index
        }

        onExited: {
            cursorFlw.visible = false
            if (index != cardBg.mainCardId  || !progressAni.running) return

            progressAni.resume()
        }
    }
}
