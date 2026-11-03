import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.theme
import qs.components
import qs.services

RowLayout {
    id: powerStatus
    height: parent.height
    spacing: Theme.style.spacing
    visible: PowerService.isPresent
    
    Text {
        text: PowerService.isPresent ? PowerService.percentage + "%" : "N/A"
        font.bold: true
        color: Theme.colors.on_surface
    }
    
    IconImage {
        id: batteryIcon
        implicitSize: parent.height
        source: Quickshell.iconPath(PowerService.iconName)
        smooth: true
    }

    Hint {
        text: PowerService.isPresent ? PowerService.remainingTime : "No battery detected"
    }
}