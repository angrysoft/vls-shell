pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services

PanelWindow {
    id: panel

    screen: Quickshell.screens[0] // albo Twoja logika multi-monitor
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "vls-shell-notifications"
    exclusiveZone: 0
    color: "transparent"

    anchors { top: true;  }
    margins { top: 12; }

    implicitWidth: 360
    implicitHeight: column.implicitHeight

    ColumnLayout {
        id: column
        width: parent.width
        spacing: 8

        Repeater {
            model: NotificationsService.list

            delegate: NotificationCard {
                required property var modelData
                notification: modelData
                Layout.fillWidth: true
            }
        }
    }
}