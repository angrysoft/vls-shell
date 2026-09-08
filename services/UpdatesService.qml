pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io

Singleton {
    id: updatesService
    property alias isAvailable: updates.isAvailable
    property alias total: updates.total
    property alias lastChecked: updates.lastChecked

    FileView {
        id: updatesFileView
        path: "/tmp/updates.json"
        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: updates
            property bool isAvailable: false
            property int total: 0
            property string lastChecked: ""
        }
    }

}