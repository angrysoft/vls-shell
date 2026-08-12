import Quickshell
import QtQuick
import Quickshell.Services.SystemTray
import qs.theme

Row {
    id: tray
    // visible: trayItems.count > 0
    anchors.verticalCenter: parent.verticalCenter
    spacing: 4

    Repeater {
        id: trayItems
        model: SystemTray.items

        SysTrayItem {
            item: model.modelData
        }
    }
}