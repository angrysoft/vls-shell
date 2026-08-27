pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    // --- Stan wystawiany na zewnątrz ---
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property bool ready: sink?.ready ?? false
    readonly property string sinkName: sink?.description ?? "Unknown"

    readonly property real micVolume: source?.audio?.volume ?? 0
    readonly property bool micMuted: source?.audio?.muted ?? false

    // Sygnał dla OSD — emitowany tylko przy realnej zmianie, nie przy każdym bindingu
    signal volumeStateChanged(real volume, bool muted)
    signal micVolumeStateChanged(real volume, bool muted)

    property real _lastVolume: -1
    property bool _lastMuted: false

    PwObjectTracker {
        objects: [ root.sink, root.source ]
    }

    // Wykrywanie realnej zmiany -> trigger OSD
    onVolumeChanged: {} // placeholder żeby nie kolidowało z propertyChanged poniżej

    Connections {
        target: root.sink?.audio ?? null
        function onVolumeChanged() { root._emitVolumeChange() }
        function onMutedChanged() { root._emitVolumeChange() }
    }

    function _emitVolumeChange() {
        if (volume !== _lastVolume || muted !== _lastMuted) {
            _lastVolume = volume
            _lastMuted = muted
            volumeStateChanged(volume, muted)
        }
    }

    // --- API dla bara / OSD ---
    function setVolume(value: real) {
        if (!sink?.ready) return
        sink.audio.volume = Math.max(0, Math.min(1.0, value))
    }

    function adjustVolume(delta: real) {
        setVolume(volume + delta)
    }

    function toggleMute() {
        if (sink?.ready) sink.audio.muted = !sink.audio.muted
    }

    function setMicVolume(value: real) {
        if (!source?.ready) return
        source.audio.volume = Math.max(0, Math.min(1.0, value))
    }

    function toggleMicMute() {
        if (source?.ready) source.audio.muted = !source.audio.muted
    }

    // --- IPC ---
    IpcHandler {
        target: "audio"

        function setVolume(value: string): string {
            root.setVolume(parseFloat(value))
            return "ok"
        }

        function increase(step: string): string {
            root.adjustVolume(parseFloat(step || "0.05"))
            return "ok"
        }

        function decrease(step: string): string {
            root.adjustVolume(-parseFloat(step || "0.05"))
            return "ok"
        }

        function toggleMute(): string {
            root.toggleMute()
            return "ok"
        }

        function status(): string {
            return JSON.stringify({
                volume: root.volume,
                muted: root.muted,
                sink: root.sinkName
            })
        }
    }
}