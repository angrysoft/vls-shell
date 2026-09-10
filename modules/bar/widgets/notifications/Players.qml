import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.theme
import qs.services

ColumnLayout {
    Layout.fillWidth: true
    spacing: Theme.style.spacing
    visible: PlayerService.hasPlayers

    Repeater {
        model: PlayerService.players

        delegate: Player {
            required property MprisPlayer modelData
            player: modelData
        }
    }
}
