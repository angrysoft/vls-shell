import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.services
import qs.theme

IconImage {
    id: logo
    implicitSize: parent.implicitHeight
    source: Quickshell.iconPath("veles-logo")
    smooth: true
    
    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped:(eventPoint, button) => {
            if (button === Qt.LeftButton) {
                LauncherService.toggle()
            } else if (button === Qt.RightButton) {
                console.log("logo right clicked")
            }
        }
    }
}
