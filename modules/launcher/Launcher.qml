import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.theme
import qs.services
import qs.components

PanelWindow {
    id: root
    property bool launcherVisible: LauncherService.launcherVisible
    visible: launcherVisible
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: launcherVisible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    exclusiveZone: -1

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    color: "transparent"

    onLauncherVisibleChanged: {
        if (launcherVisible) {
            searchField.text = "";
            searchField.forceActiveFocus();
            visible = true;
        } else {
            visible = false;
        }
    }

    // klik poza oknem = zamknięcie
    MouseArea {
        anchors.fill: parent
        onClicked: LauncherService.hide()
    }

    Rectangle {
        id: box
        width: 560
        height: 420
        // anchors.horizontalCenter: parent.horizontalCenter
        anchors.centerIn: parent
        y: 120
        radius: Theme.style.dialogRadius
        color: Theme.colors.surface
        border.color: Theme.colors.outline
        border.width: Theme.style.borderWidth
        scale: root.launcherVisible ? 1.0 : 0.55
        opacity: root.launcherVisible ? 1.0 : 0.0

        Behavior on scale {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 120
            }
        }

        MouseArea {
            anchors.fill: parent
        } // pochłania klik, nie zamyka

        Column {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            StyledTextField {
                id: searchField
                width: parent.width
                placeholderText: qsTr("Search...")
                focus: launcherVisible

                onTextChanged: LauncherService.updateFilter(text)

                Keys.onDownPressed: LauncherService.moveSelection(1)
                Keys.onUpPressed: LauncherService.moveSelection(-1)
                Keys.onReturnPressed: LauncherService.launchSelected()
                Keys.onEscapePressed: LauncherService.hide()
            }

            ListView {
                id: resultsView
                width: parent.width
                height: parent.height - searchField.height - 8
                clip: true
                model: LauncherService.filtered
                currentIndex: LauncherService.selectedIndex
                highlightMoveDuration: 80

                delegate: LauncherEntry {
                    width: resultsView.width
                    entry: modelData
                    isSelected: index === LauncherService.selectedIndex
                    onClicked: {
                        LauncherService.selectedIndex = index;
                        LauncherService.launchSelected();
                    }
                }
            }
        }
    }
}
