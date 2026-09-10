pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: playerService
    readonly property var players: Mpris.players.values.filter(p => p.canPlay)
    readonly property bool hasPlayers: players.length > 0
}
