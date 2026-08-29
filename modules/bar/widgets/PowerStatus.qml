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

    HoverHandler {
        id: hoverHandler
    }

    PopupWindow {
        id: tooltip
        visible: hoverHandler.hovered
        
        // Position relative to the parent item
        anchor.item: powerStatus
        // anchor.rect: Qt.rect(powerStatus.x, powerStatus.y, powerStatus.width, powerStatus.height)
        anchor.edges: Edges.Bottom | Edges.Left
        anchor.gravity: Edges.Bottom | Edges.Right

        color: "transparent"

        Rectangle {
            implicitWidth: tipText.implicitWidth + 16
            implicitHeight: tipText.implicitHeight + 8
            color: Theme.colors.surface
            border.color: Theme.colors.outline
            border.width: 1
            radius: 4

            Text {
                id: tipText
                anchors.centerIn: parent
                text: PowerService.isPresent ? PowerService.stateRemainingTime : "No battery detected"
                color: Theme.colors.on_surface
                font.pixelSize: 12
            }
        }
    }
}