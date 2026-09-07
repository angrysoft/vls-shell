pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications


Singleton {
    id: root

    readonly property alias list: server.trackedNotifications
    property bool hasNotifications: historyAdapter.entries.some(entry => !entry.read)
    property bool historyFileReady: false

    Process {
        id: initializeHistoryFile
        command: ["sh", "-c", "mkdir -p \"$HOME/.local/state/vls-shell\" && [ -e \"$HOME/.local/state/vls-shell/notifications.json\" ] || printf '%s\\n' '{\"entries\":[]}' > \"$HOME/.local/state/vls-shell/notifications.json\""]
        running: true
        onRunningChanged: {
            if (!running) {
                root.historyFileReady = true
            }
        }
    }

    NotificationServer {
        id: server
        keepOnReload: false
        actionsSupported: true
        actionIconsSupported: true
        bodySupported: true
        bodyMarkupSupported: true
        bodyImagesSupported: true
        imageSupported: true
        persistenceSupported: false

        onNotification: notification => {
            if (notification.transient) {
                return;
            }
            notification.tracked = true
            root.storeInHistory(notification)

        }
    }

    function storeInHistory(item) {
        const entry = {
            id: item.id,
            time: Date.now(),
            appName: item.appName,
            appIcon: item.appIcon ? String(item.appIcon) : "",
            image: item.image ? String(item.image) : "",
            summary: item.summary,
            body: item.body,
            urgency: item.urgency,
            read: false
        }
        let updated = historyAdapter.entries.slice()
        updated.unshift(entry)
        if (updated.length > 200) updated = updated.slice(0, 200)
        historyAdapter.entries = updated
    }

    function markAllRead() {
        historyAdapter.entries = historyAdapter.entries.map(entry => {
            const updatedEntry = {}
            for (const property in entry) updatedEntry[property] = entry[property]
            updatedEntry.read = true
            return updatedEntry
        })
    }

    function removeFromHistory(id, time) {
        historyAdapter.entries = historyAdapter.entries.filter(
            e => !(e.id === id && e.time === time)
        )
    }

    function clearHistory() {
        historyAdapter.entries = []
    }

    function dismiss(notification) {
        notification.dismiss()
    }

    function getHistory() {
        return historyAdapter.entries
    }

    FileView {
        id: fileView
        path: root.historyFileReady ? Quickshell.env("HOME") + "/.local/state/vls-shell/notifications.json" : ""
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: {
            if (root.historyFileReady) {
                writeAdapter()
            }
        }

        JsonAdapter {
            id: historyAdapter
            property var entries: []
        }
    }

    IpcHandler {
        target: "notifications"

        function clearHistory() { root.clearHistory() }
        function markAllRead() { root.markAllRead() }
        function status(): string {
            return JSON.stringify({
                hasNotifications: root.hasNotifications,
                length: historyAdapter.entries.length,
            })
        }
    }
}