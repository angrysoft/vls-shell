import Quickshell
import QtQuick
import qs.theme
import qs.components

TextLabel {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    readonly property var plLocale: Qt.locale()

    text: plLocale.toString(clock.date, "ddd d MMM hh:mm:ss")
    
    bold: true
}