import Quickshell
import QtQuick
import qs.components
import qs.config

TextLabel {
    id: clockView
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    readonly property var locale: Qt.locale()
    readonly property string format: Config.modules.bar.clockFormat ? Config.modules.bar.clockFormat : "ddd d MMM hh:mm:ss"

    text: locale.toString(clock.date, format)
    
    bold: true
}