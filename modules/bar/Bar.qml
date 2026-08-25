

import Quickshell
import Quickshell.Widgets
import Quickshell.I3
import Quickshell.Io
import QtQuick
import qs.theme
import qs.modules.bar.widgets
import qs.config


PanelWindow {
    id: bar
    property string position: Config.modules.bar.position

    anchors {
        top: bar.position !== "bottom"
        bottom: bar.position !== "top"
        // left: bar.position !== "right"
        // right: bar.position !== "left"
        left: true
        right: true
    }

    implicitHeight: Theme.style.barHeight + Theme.style.padding * 2
    color: Theme.style.barBackgroundColor ?? Theme.colors.surface
    

        // ── Left: Workspaces ─────────────────────────────────────
        WrapperRectangle {
            id: leftWrapper
            anchors.left: parent.left
            anchors.leftMargin: Theme.style.margin
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.colors.surface
            implicitHeight: Theme.style.barHeight
            topMargin: Theme.style.barHeight / 2 - Theme.style.fontSize + Theme.style.padding
            bottomMargin: topMargin
            leftMargin: topMargin * 4
            rightMargin: leftMargin
            radius: implicitHeight / 2

            Row {
                // anchors.left: parent.left
                // anchors.leftMargin: Theme.style.margin
                // anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.style.spacing
                
                Menu {}
                Workspaces {}
                ActiveWindow {}

            }
        }

        // ── Center: Clock ─────────────────────────────────────────
        WrapperRectangle {
                id: centerWrapper
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.colors.surface
                implicitHeight: Theme.style.barHeight
                topMargin: Theme.style.barHeight / 2 - Theme.style.fontSize + Theme.style.padding
                bottomMargin: topMargin
                leftMargin: topMargin * 4
                rightMargin: leftMargin
                radius: implicitHeight / 2

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.style.spacing
                Clock {}
                
            }
        }
        // ── Right: System Tray ────────────────────────────────────
        WrapperRectangle {
            id: rightWrapper
            anchors.right: parent.right
            anchors.rightMargin: Theme.style.margin
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.colors.surface
            implicitHeight: Theme.style.barHeight
            topMargin: Theme.style.barHeight / 2 - Theme.style.fontSize + Theme.style.padding
            bottomMargin: topMargin
            leftMargin: topMargin * 4
            rightMargin: leftMargin
            radius: implicitHeight / 2
            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.style.spacing


                SysTray {
                }
                
                Shutdown {
                }
            
            }
        }
}
