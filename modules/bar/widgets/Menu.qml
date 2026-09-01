import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.services

IconImage {
    id: logo
    implicitSize: parent.implicitHeight
    source: Quickshell.iconPath("archlinux-logo", "distributor-logo-archlinux")
    smooth: true
    
    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped:(eventPoint, button) => {
            if (button === Qt.LeftButton) {
                LauncherService.toggle()
            } else if (button === Qt.RightButton) {
                console.log("Arch Linux logo right clicked")
            }
        }
    }
}
