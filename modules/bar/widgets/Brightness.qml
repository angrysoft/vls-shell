import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import qs.theme
import qs.components
import qs.services

Row {
    id: brightness
    spacing: Theme.style.spacing
    property real brightnessLevel: Math.floor(BrightnessService.percent * 100)
    visible: BrightnessService.device.length > 0

    TextLabel {
        text: brightness.brightnessLevel + "%"
        maximumLineCount: 1
        bold: true
    }

    IconImage {
        id: brightnessIcon
        implicitSize: parent.height
        source: Quickshell.iconPath(BrightnessService.getIconName())
        smooth: true
    }

    Hint {
        text: BrightnessService.device
    }
}