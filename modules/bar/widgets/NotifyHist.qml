import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.services

IconImage {
    id: notify
    implicitSize: parent.implicitHeight
    source: Quickshell.iconPath(NotificationsService.hasNotifications ? "notification-new-symbolic" : "notification-symbolic")
    smooth: true
    // visible: NotificationsService.hasNotifications
    
    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped:(eventPoint, button) => {
            if (button === Qt.LeftButton) {
                console.log("logo left clicked")
            } else if (button === Qt.RightButton) {
                console.log("logo right clicked")
            }
        }
    }
}
