import QtQuick
import Quickshell
import Quickshell.Widgets

import qs.services
import qs.theme
import qs.components

IconImage {
    id: updatesIcon
    implicitSize: parent.height
    source: Quickshell.iconPath("software-update-available")
    smooth: true
    visible: UpdatesService.isAvailable
    
    Hint {
        text: UpdatesService.isAvailable ? "Updates available: " + UpdatesService.total : "No updates available"
    }
}