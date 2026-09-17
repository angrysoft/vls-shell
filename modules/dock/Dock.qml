import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.config

Scope {
    id: dockScope

    // Trzymaj tu tylko ID .desktop (nazwa pliku bez rozszerzenia)
    readonly property var favoriteIds: Config.modules.dock.apps

    // Rozwiązanie ID -> DesktopEntry (pomijamy brakujące)
    readonly property var favorites: favoriteIds.map(id => DesktopEntries.byId(id)).filter(entry => entry !== null)

    property bool revealed: true
    property bool pinnedOpen: false // np. po IPC "show"

    PanelWindow {
        id: dockWindow
        anchors {
            bottom: true
        }
        exclusiveZone: 0
        color: "transparent"

        implicitWidth: Screen.width
        implicitHeight: 80

        // Cienki pasek-wyzwalacz na samej krawędzi ekranu
        MouseArea {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: dockContainer.implicitWidth
            height: dockScope.revealed ? dockContainer.height : 4
            hoverEnabled: true
            // onEntered: hideTimer.stop()
            onEntered: dockScope.revealed = true
            onExited: hideTimer.restart()

            Rectangle {
                id: dockContainer
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: dockScope.revealed ? 8 : -implicitHeight
                implicitWidth: dockRow.implicitWidth + 24
                implicitHeight: 64
                radius: 18
                color: "#19120c"
                border.color: Qt.rgba(1, 1, 1, 0.06)
                border.width: 1

                Behavior on anchors.bottomMargin {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                    }
                }

                RowLayout {
                    id: dockRow
                    anchors.centerIn: parent
                    spacing: 10

                    Repeater {
                        model: dockScope.favorites

                        delegate: DockIcon {
                            required property var modelData
                            appName: modelData.name
                            iconName: modelData.icon
                            onClicked: {
                                modelData.execute();
                                hideTimer.restart();
                            }
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: hideTimer
        interval: 600
        onTriggered: {
            if (!dockScope.pinnedOpen)
                dockScope.revealed = false;
        }
    }

    IpcHandler {
        target: "dock"

        function toggle(): void {
            dockScope.pinnedOpen = !dockScope.pinnedOpen;
            dockScope.revealed = dockScope.pinnedOpen;
        }

        function show(): void {
            dockScope.revealed = true;
            hideTimer.stop();
        }

        function hide(): void {
            dockScope.pinnedOpen = false;
            dockScope.revealed = false;
        }
    }
}
