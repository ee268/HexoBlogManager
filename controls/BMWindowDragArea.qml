import QtQuick

Item {
    property var window: undefined
    property int dragAreaWidth: 8

    MouseArea {
        id: leftDrag
        width: dragAreaWidth
        height: parent.height - dragAreaWidth * 2
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        cursorShape: Qt.SizeHorCursor

        property point initPos: "0, 0"
        property real initWidth: 0
        property real initWindowX: 0

        onPressed: (mouse) => {
            initPos = leftDrag.mapToGlobal(mouse.x, mouse.y)
            initWidth = window.width
            initWindowX = window.x
            // console.log(clickPos)
        }

        onPositionChanged: (mouse) => {
            let screenPos = leftDrag.mapToGlobal(mouse.x, mouse.y)
            let delta = Qt.point(screenPos.x - initPos.x, screenPos.y - initPos.y)

            let newWidth = initWidth - delta.x
            let newX = initWindowX + delta.x

            if (newWidth >= window.maximumWidth) {
                window.width = window.maximumWidth
            }
            else if (newWidth >= window.minimumWidth) {
                window.width = newWidth
                window.x = newX
            }
            else {
                window.width = window.minimumWidth
            }
        }
    }

    MouseArea {
        id: rightDrag
        width: dragAreaWidth
        height: parent.height - dragAreaWidth * 2
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        cursorShape: Qt.SizeHorCursor

        property point initPos: "0, 0"
        property real initWidth: 0

        onPressed: (mouse) => {
            initPos = rightDrag.mapToGlobal(mouse.x, mouse.y)
            initWidth = window.width
        }

        onPositionChanged: (mouse) => {
            let screenPos = rightDrag.mapToGlobal(mouse.x, mouse.y)
            let delta = Qt.point(screenPos.x - initPos.x, screenPos.y - initPos.y)

            let newWidth = initWidth + delta.x

            if (newWidth >= window.maximumWidth) {
                window.width = window.maximumWidth
            }
            else if (newWidth >= window.minimumWidth) {
                window.width = newWidth
            }
            else {
                window.width = window.minimumWidth
            }
        }
    }

    MouseArea {
        id: topDrag
        width: parent.width - dragAreaWidth * 2
        height: dragAreaWidth
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
        }
        cursorShape: Qt.SizeVerCursor

        property point initPos: "0, 0"
        property real initHeight: 0
        property real initWindowY: 0

        onPressed: (mouse) => {
            initPos = topDrag.mapToGlobal(mouse.x, mouse.y)
            initHeight = window.height
            initWindowY = window.y
            // console.log(clickPos)
        }

        onPositionChanged: (mouse) => {
            let screenPos = topDrag.mapToGlobal(mouse.x, mouse.y)
            let delta = Qt.point(screenPos.x - initPos.x, screenPos.y - initPos.y)

            let newHeight = initHeight - delta.y
            let newY = initWindowY + delta.y

            if (newHeight >= window.maximumHeight) {
                window.height = window.maximumHeight
            }
            else if (newHeight >= window.minimumHeight) {
                window.height = newHeight
                window.y = newY
            }
            else {
                window.height = window.minimumHeight
            }
        }
    }

    MouseArea {
        id: bottomDrag
        width: parent.width - dragAreaWidth * 2
        height: dragAreaWidth
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        cursorShape: Qt.SizeVerCursor

        property point initPos: "0, 0"
        property real initHeight: 0

        onPressed: (mouse) => {
            initPos = bottomDrag.mapToGlobal(mouse.x, mouse.y)
            initHeight = window.height
            // console.log(clickPos)
        }

        onPositionChanged: (mouse) => {
            let screenPos = bottomDrag.mapToGlobal(mouse.x, mouse.y)
            let delta = Qt.point(screenPos.x - initPos.x, screenPos.y - initPos.y)

            let newHeight = initHeight + delta.y

            if (newHeight >= window.maximumHeight) {
                window.height = window.maximumHeight
            }
            else if (newHeight >= window.minimumHeight) {
                window.height = newHeight
            }
            else {
                window.height = window.minimumHeight
            }
        }
    }

    MouseArea {
        id: topLeftDrag
        width: dragAreaWidth
        height: dragAreaWidth
        anchors {
            top: parent.top
            left: parent.left
        }
        cursorShape: Qt.SizeFDiagCursor

        property point initPos: "0, 0"
        property real initHeight: 0
        property real initWindowY: 0
        property real initWidth: 0
        property real initWindowX: 0

        onPressed: (mouse) => {
            initPos = topLeftDrag.mapToGlobal(mouse.x, mouse.y)
            initHeight = window.height
            initWindowY = window.y
            initWidth = window.width
            initWindowX = window.x
            // console.log(clickPos)
        }

        onPositionChanged: (mouse) => {
            let screenPos = topLeftDrag.mapToGlobal(mouse.x, mouse.y)
            let delta = Qt.point(screenPos.x - initPos.x, screenPos.y - initPos.y)

            let newHeight = initHeight - delta.y
            let newY = initWindowY + delta.y
            let newWidth = initWidth - delta.x
            let newX = initWindowX + delta.x

            if (newHeight >= window.maximumHeight &&
                newWidth >= window.maximumWidth)
            {
                window.height = window.maximumHeight
                window.width = window.maximumWidth
            }
            else if (newHeight >= window.minimumHeight &&
                     newWidth >= window.minimumWidth)
            {
                window.height = newHeight
                window.y = newY
                window.width = newWidth
                window.x = newX
            }
            else {
                window.height = window.minimumHeight
                window.width = window.minimumWidth
            }
        }
    }

    MouseArea {
        id: topRightDrag
        width: dragAreaWidth
        height: dragAreaWidth
        anchors {
            top: parent.top
            right: parent.right
        }
        cursorShape: Qt.SizeBDiagCursor

        property point initPos: "0, 0"
        property real initHeight: 0
        property real initWindowY: 0
        property real initWidth: 0

        onPressed: (mouse) => {
            initPos = topRightDrag.mapToGlobal(mouse.x, mouse.y)
            initHeight = window.height
            initWindowY = window.y
            initWidth = window.width
            // console.log(clickPos)
        }

        onPositionChanged: (mouse) => {
            let screenPos = topRightDrag.mapToGlobal(mouse.x, mouse.y)
            let delta = Qt.point(screenPos.x - initPos.x, screenPos.y - initPos.y)

            let newHeight = initHeight - delta.y
            let newY = initWindowY + delta.y
            let newWidth = initWidth + delta.x

            if (newHeight >= window.maximumHeight &&
                newWidth >= window.maximumWidth)
            {
                window.height = window.maximumHeight
                window.width = window.maximumWidth
            }
            else if (newHeight >= window.minimumHeight &&
                     newWidth >= window.minimumWidth)
            {
                window.height = newHeight
                window.y = newY
                window.width = newWidth
            }
            else {
                window.height = window.minimumHeight
                window.width = window.minimumWidth
            }
        }
    }

    MouseArea {
        id: bottomLeftDrag
        width: dragAreaWidth
        height: dragAreaWidth
        anchors {
            bottom: parent.bottom
            left: parent.left
        }
        cursorShape: Qt.SizeBDiagCursor

        property point initPos: "0, 0"
        property real initHeight: 0
        property real initWidth: 0
        property real initWindowX: 0

        onPressed: (mouse) => {
            initPos = bottomLeftDrag.mapToGlobal(mouse.x, mouse.y)
            initHeight = window.height
            initWidth = window.width
            initWindowX = window.x
            // console.log(clickPos)
        }

        onPositionChanged: (mouse) => {
            let screenPos = bottomLeftDrag.mapToGlobal(mouse.x, mouse.y)
            let delta = Qt.point(screenPos.x - initPos.x, screenPos.y - initPos.y)

            let newHeight = initHeight + delta.y
            let newWidth = initWidth - delta.x
            let newX = initWindowX + delta.x

            if (newHeight >= window.maximumHeight &&
                newWidth >= window.maximumWidth)
            {
                window.height = window.maximumHeight
                window.width = window.maximumWidth
            }
            else if (newHeight >= window.minimumHeight &&
                     newWidth >= window.minimumWidth)
            {
                window.height = newHeight
                window.width = newWidth
                window.x = newX
            }
            else {
                window.height = window.minimumHeight
                window.width = window.minimumWidth
            }
        }
    }

    MouseArea {
        id: bottomRightDrag
        width: dragAreaWidth
        height: dragAreaWidth
        anchors {
            bottom: parent.bottom
            right: parent.right
        }
        cursorShape: Qt.SizeFDiagCursor

        property point initPos: "0, 0"
        property real initHeight: 0
        property real initWidth: 0

        onPressed: (mouse) => {
            initPos = bottomRightDrag.mapToGlobal(mouse.x, mouse.y)
            initHeight = window.height
            initWidth = window.width
        }

        onPositionChanged: (mouse) => {
            let screenPos = bottomRightDrag.mapToGlobal(mouse.x, mouse.y)
            let delta = Qt.point(screenPos.x - initPos.x, screenPos.y - initPos.y)

            let newHeight = initHeight + delta.y
            let newWidth = initWidth + delta.x

            if (newHeight >= window.maximumHeight &&
                newWidth >= window.maximumWidth)
            {
                window.height = window.maximumHeight
                window.width = window.maximumWidth
            }
            else if (newHeight >= window.minimumHeight &&
                     newWidth >= window.minimumWidth)
            {
                window.height = newHeight
                window.width = newWidth
            }
            else {
                window.height = window.minimumHeight
                window.width = window.minimumWidth
            }
        }
    }
}
