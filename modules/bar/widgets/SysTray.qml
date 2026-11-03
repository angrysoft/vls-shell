import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import qs.theme

RowLayout {
    id: tray
    visible: trayItems.count > 0
    Layout.preferredHeight: parent.height - Theme.style.padding * 2
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