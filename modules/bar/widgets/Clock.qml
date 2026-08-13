import Quickshell
import QtQuick
import qs.components
import qs.config

TextLabel {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    readonly property var plLocale: Qt.locale()
    property string format: Config.modules.bar.clockFormat ? Config.modules.bar.clockFormat : "ddd d MMM hh:mm:ss"

    text: plLocale.toString(clock.date, format)
    
    bold: true
}