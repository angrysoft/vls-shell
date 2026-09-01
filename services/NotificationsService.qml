pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    readonly property alias list: server.trackedNotifications

    NotificationServer {
        id: server
        keepOnReload: false
        actionsSupported: true
        actionIconsSupported: false
        bodySupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: true
        imageSupported: true
        persistenceSupported: false

        onNotification: notification => {
            notification.tracked = true
        }
    }

    function dismiss(notification) {
        notification.dismiss()
    }
}