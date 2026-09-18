import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.config
import qs.theme

Scope {
    id: dockScope
    readonly property var apps: Config.modules.dock.apps

    onAppsChanged: {
        updateTimer.restart();
    }

    property var favorites: []

    function updateFavorites() {
        var configApps = dockScope.apps || [];
        var list = [];

        for (var i = 0; i < configApps.length; i++) {
            var appId = configApps[i];
            var entry = DesktopEntries.byId(appId);

            if (entry) {
                list.push(entry);
            }
        }
        dockScope.favorites = list;
        return list;
    }

    Timer {
        id: updateTimer
        interval: 50
        repeat: false
        onTriggered: dockScope.updateFavorites()
    }

    Connections {
        target: DesktopEntries.applications

        function onValuesChanged() {
            updateTimer.restart();
        }
    }

    Component.onCompleted: {
        updateTimer.restart();
    }

    property bool revealed: !Config.modules.dock.autoHide
    property bool autoHide: Config.modules.dock.autoHide

    PanelWindow {
        id: dockWindow
        anchors {
            bottom: true
        }
        exclusiveZone: 0
        color: "transparent"
        visible: dockScope.favorites.length > 0

        implicitWidth: dockContainer.implicitWidth
        // implicitHeight: 200

        MouseArea {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: dockContainer.implicitWidth
            height: dockScope.revealed ? dockContainer.height : Theme.style.dialogPadding
            hoverEnabled: true
            onEntered: {
                hideTimer.stop();
                dockScope.revealed = true;
            }
            onExited: hideTimer.restart()

            Rectangle {
                id: dockContainer
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: dockScope.revealed ? 8 : -implicitHeight
                implicitWidth: dockRow.implicitWidth + 24
                implicitHeight: 64 + Theme.style.dialogPadding
                radius: Theme.style.dialogRadius
                color: Theme.colors.surface
                border.color: Theme.colors.outline
                border.width: Theme.style.borderWidth

                Behavior on anchors.bottomMargin {
                    NumberAnimation {
                        duration: 180
                        easing.type: Easing.OutCubic
                    }
                }

                RowLayout {
                    id: dockRow
                    anchors.centerIn: parent
                    spacing: Theme.style.spacing

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
            if (dockScope.autoHide)
                dockScope.revealed = false;
        }
    }

    IpcHandler {
        target: "dock"

        function toggle(): void {
            dockScope.autoHide = !dockScope.autoHide;
            dockScope.revealed = !dockScope.autoHide;
        }

        function show(): void {
            dockScope.revealed = true;
            hideTimer.stop();
        }

        function hide(): void {
            dockScope.autoHide = true;
            dockScope.revealed = false;
        }
    }
}
