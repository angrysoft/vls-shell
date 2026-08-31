import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.theme

PanelWindow {
    id: root

    property bool launcherVisible: false
    property var filtered: []
    property int selectedIndex: 0

    visible: launcherVisible
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: launcherVisible
        ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.None
    exclusiveZone: -1

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    color: "transparent"

    // klik poza oknem = zamknięcie
    MouseArea {
        anchors.fill: parent
        onClicked: root.hide()
    }

    Rectangle {
        id: box
        width: 560
        height: 420
        // anchors.horizontalCenter: parent.horizontalCenter
        anchors.centerIn: parent
        y: 120
        radius: 14
        color: Theme.colors.surface
        border.color: Theme.colors.outline
        border.width: 1

        MouseArea { anchors.fill: parent } // pochłania klik, nie zamyka

        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            TextField {
                id: searchField
                width: parent.width
                padding: Theme.style.padding
                font.pixelSize: Theme.style.fontSize
                placeholderText: qsTr("Search...")
                focus: root.launcherVisible
                color: Theme.colors.on_surface

                background: Rectangle {
                    border.width: 0
                    color: "transparent"
                }

                onTextChanged: root.updateFilter(text)

                Keys.onDownPressed: root.moveSelection(1)
                Keys.onUpPressed: root.moveSelection(-1)
                Keys.onReturnPressed: root.launchSelected()
                Keys.onEscapePressed: root.hide()
            }

            ListView {
                id: resultsView
                width: parent.width
                height: parent.height - searchField.height - 8
                clip: true
                model: root.filtered
                currentIndex: root.selectedIndex
                highlightMoveDuration: 80

                delegate: LauncherEntry {
                    width: resultsView.width
                    entry: modelData
                    isSelected: index === root.selectedIndex
                    onClicked: {
                        root.selectedIndex = index
                        root.launchSelected()
                    }
                }
            }
        }
    }

    function show() {
        launcherVisible = true
        searchField.text = ""
        updateFilter("")
        searchField.forceActiveFocus()
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
        function toggle() { root.toggle() }
        function show() { root.show() }
        function hide() { root.hide() }
    }
}