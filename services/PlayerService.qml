pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris

Singleton {
    id: playerService
    readonly property var players: Mpris.players.values.filter(p => p.canPlay)
    readonly property bool hasPlayers: players.length > 0
    readonly property MprisPlayer currentPlayer: players.length > 0 ? players[0] : null

    function play() {
        if (playerService.currentPlayer) {
            playerService.currentPlayer.play();
        }
    }

    function pause() {
        if (playerService.currentPlayer) {
            playerService.currentPlayer.pause();
        }
    }

    function playPause() {
        if (playerService.currentPlayer) {
            playerService.currentPlayer.togglePlaying();
        }
    }

    function next() {
        if (playerService.currentPlayer) {
            playerService.currentPlayer.next();
        }
    }

    function previous() {
        if (playerService.currentPlayer) {
            playerService.currentPlayer.previous();
        }
    }

    IpcHandler {
        target: "player"
        function status(): string {
            return JSON.stringify({
                hasPlayers: playerService.hasPlayers,
                currentPlayer: playerService.currentPlayer ? {
                    trackTitle: playerService.currentPlayer.trackTitle,
                    trackArtist: playerService.currentPlayer.trackArtist,
                    trackArtUrl: playerService.currentPlayer.trackArtUrl,
                    playbackState: playerService.currentPlayer.playbackState
                } : null
            });
        }

        function play() {
            playerService.play();
        }
        function pause() {
            playerService.pause();
        }
        function playPause() {
            playerService.playPause();
        }
        function next() {
            playerService.next();
        }
        function previous() {
            playerService.previous();
        }
    }
}
