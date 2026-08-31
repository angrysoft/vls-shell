import Quickshell
import Quickshell.Widgets
import QtQuick

import qs.theme
import qs.components
import qs.services

Row {
    id: powerStatus
    height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    spacing: Theme.style.spacing
    visible: true
    
    Component.onCompleted: {
        console.log("PowerStatus component initialized. Battery present:", PowerService.isPresent, "Percentage:", PowerService.remainingTime, "Charging:", PowerService.battery.powerSupply)
    }

    TextLabel {
        anchors.verticalCenter: parent.verticalCenter
        text: PowerService.isPresent ? PowerService.percentage + "%" : "N/A"
        bold: true
        visible: PowerService.isPresent
    }
    
    IconImage {
        id: batteryIcon
        implicitSize: parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: Quickshell.iconPath(PowerService.iconName)
        smooth: true
    }

    Hint {
        text: PowerService.isPresent ? PowerService.remainingTime : "No battery detected"
    }
}