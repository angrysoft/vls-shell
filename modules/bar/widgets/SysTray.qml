import Quickshell
import QtQuick
import Quickshell.Services.SystemTray
import qs.theme

Row {
    id: tray
    visible: trayItems.count > 0
    height: parent.height
    spacing: Theme.style.spacing

    Repeater {
        id: trayItems
        model: SystemTray.items

        SysTrayItem {
            required property SystemTrayItem modelData
            item: modelData
        }
    }
}