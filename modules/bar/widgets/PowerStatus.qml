import Quickshell
import Quickshell.Widgets
import QtQuick

import qs.theme
import qs.components
import qs.services

Row {
    id: powerStatus
    height: parent.height
    spacing: Theme.style.spacing
    visible: true
    
    TextLabel {
        text: PowerService.isPresent ? PowerService.percentage + "%" : "N/A"
        bold: true
        visible: PowerService.isPresent
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