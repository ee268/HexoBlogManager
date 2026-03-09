pragma Singleton
import QtQuick

QtObject {
   id: config
   property bool isLightMode: true
   property int aniDuration: 500
   property int titleBarHeight: 32
   property int windowDistance: 8
   property color themeColor: "#4682b4"
   property string font: "qrc:/res/font/dingliezhuhaifont-20240831GengXinBan)-2.ttf"
   property int curMenu: 0
   property bool isTopMenu: true

   readonly property color light: "#fdfbfb"
   readonly property color dark: "#2b2b2b"
}
