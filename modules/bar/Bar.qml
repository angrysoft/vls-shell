

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
    readonly property string position: Config.modules.bar.position
    readonly property real calcTopMargin: Theme.style.barHeight / 2 - Theme.style.fontSize + Theme.style.padding
    readonly property real calcSideMargin: calcTopMargin * 4
    readonly property real widgetSpacing: Theme.style.spacing * 2

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
            topMargin: bar.calcTopMargin
            bottomMargin: bar.calcTopMargin
            leftMargin: bar.calcSideMargin
            rightMargin: bar.calcSideMargin
            radius: implicitHeight / 2

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: bar.widgetSpacing
                
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
                topMargin: bar.calcTopMargin
                bottomMargin: bar.calcTopMargin
                leftMargin: bar.calcSideMargin
                rightMargin: bar.calcSideMargin
                radius: implicitHeight / 2

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: bar.widgetSpacing
                Clock {}
                
            }
        }



        WrapperRectangle {
            id: infoWrapper
            anchors.right: rightWrapper.left
            anchors.rightMargin: Theme.style.margin
            anchors.verticalCenter: parent.verticalCenter
            color: Theme.colors.surface
            implicitHeight: Theme.style.barHeight
            topMargin: bar.calcTopMargin
            bottomMargin: bar.calcTopMargin
            leftMargin: bar.calcSideMargin
            rightMargin: bar.calcSideMargin
            radius: implicitHeight / 2

            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: bar.widgetSpacing
                MemMonitor {}
                CpuMonitor {}
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
            topMargin: bar.calcTopMargin
            bottomMargin: bar.calcTopMargin
            leftMargin: bar.calcSideMargin
            rightMargin: bar.calcSideMargin
            radius: implicitHeight / 2
            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: bar.widgetSpacing
                SysTray {}
                Volume {}
                PowerStatus {}
                Shutdown {}
            }
        }
}
