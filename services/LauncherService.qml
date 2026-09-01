pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io


Singleton {
    id: launcherService
    property bool launcherVisible: false
    property var filtered: []
    property int selectedIndex: 0
    property string searchText 

    function show() {
        launcherVisible = true
        searchText = ""
        updateFilter("")
        // searchField.forceActiveFocus()
    }

    function hide() {
        launcherVisible = false
    }

    function toggle() {
        launcherVisible ? hide() : show()
    }

    function updateFilter(query) {
        selectedIndex = 0
        const apps = DesktopEntries.applications.values
        if (!query) {
            filtered = apps.slice(0, 50)
            return
        }
        const q = query.toLowerCase()
        const scored = []
        for (const app of apps) {
            const name = (app.name || "").toLowerCase()
            const score = fuzzyScore(q, name)
            if (score > 0) scored.push({ app, score })
        }
        scored.sort((a, b) => b.score - a.score)
        filtered = scored.map(s => s.app).slice(0, 50)
    }

    function fuzzyScore(query, target) {
        // proste dopasowanie podsekwencyjne (jak fuzzel/fzf), bez zależności
        let qi = 0
        let score = 0
        let consecutive = 0
        for (let ti = 0; ti < target.length && qi < query.length; ti++) {
            if (target[ti] === query[qi]) {
                qi++
                consecutive++
                score += consecutive
                if (ti === 0) score += 5 // bonus za dopasowanie od początku
            } else {
                consecutive = 0
            }
        }
        return qi === query.length ? score : 0
    }

    function moveSelection(delta) {
        if (filtered.length === 0) return
        selectedIndex = (selectedIndex + delta + filtered.length) % filtered.length
    }

    function launchSelected() {
        if (filtered.length === 0) return
        const app = filtered[selectedIndex]
        app.execute()
        hide()
    }

    IpcHandler {
        target: "launcher"
        function toggle() { launcherService.toggle() }
        function show() { launcherService.show() }
        function hide() { launcherService.hide() }
    }
}