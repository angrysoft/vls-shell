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
    readonly property string name: sink?.description ?? "Unknown"

    readonly property real micVolume: source?.audio?.volume ?? 0
    readonly property bool micMuted: source?.audio?.muted ?? false
    property bool sinkRouted: false

    // Sygnał dla OSD — emitowany tylko przy realnej zmianie, nie przy każdym bindingu
    signal volumeStateChanged(real volume, bool muted)
    signal micVolumeStateChanged(real volume, bool muted)

    property real _lastVolume: -1
    property bool _lastMuted: false
    property real _lastMicVolume: -1
    property bool _lastMicMuted: false

    PwObjectTracker {
        objects: [root.sink, root.source]
    }

    // Wykrywanie realnej zmiany -> trigger OSD
    onVolumeChanged: {} // placeholder żeby nie kolidowało z propertyChanged poniżej

    Connections {
        target: root.sink ? root.sink.audio : null
        ignoreUnknownSignals: true

        function onVolumeChanged() {
            root._emitVolumeChange();
        }
        function onMutedChanged() {
            root._emitVolumeChange();
        }
    }

    // Bezpieczne powiązanie sygnałów dla mikrofonu (Source)
    Connections {
        target: root.source ? root.source.audio : null
        ignoreUnknownSignals: true

        function onVolumeChanged() {
            root._emitMicVolumeChange();
        }
        function onMutedChanged() {
            root._emitMicVolumeChange();
        }
    }

    onSinkChanged: _emitVolumeChange()
    onSourceChanged: _emitMicVolumeChange()

    function _emitVolumeChange() {
        if (volume !== _lastVolume || muted !== _lastMuted) {
            _lastVolume = volume;
            _lastMuted = muted;
            if (sink?.name.startsWith("bluez")) {
                root.sinkRouted = true;
            } else {
                root.sinkRouted = false;
            }
            volumeStateChanged(volume, muted);
        }
    }

    function _emitMicVolumeChange() {
        if (micVolume !== _lastMicVolume || micMuted !== _lastMicMuted) {
            _lastMicVolume = micVolume;
            _lastMicMuted = micMuted;
            micVolumeStateChanged(micVolume, micMuted);
        }
    }

    // --- API dla bara / OSD ---
    function setVolume(value: real) {
        if (!sink?.ready)
            return;
        let valueToSet = Math.max(0, Math.min(1.0, value));
        if (sinkRouted) {
            Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", valueToSet]);
        } else {
            sink.audio.volume = valueToSet;
        }
    }

    function adjustVolume(delta: real) {
        setVolume(volume + delta);
    }

    function toggleMute() {
        if (sink?.ready)
            sink.audio.muted = !sink.audio.muted;
    }

    function setMicVolume(value: real) {
        if (!source?.ready)
            return;
        source.audio.volume = Math.max(0, Math.min(1.0, value));
    }

    function toggleMicMute() {
        if (source?.ready)
            source.audio.muted = !source.audio.muted;
    }

    // --- IPC ---
    IpcHandler {
        target: "volume"

        function setVolume(value: string): string {
            root.setVolume(parseFloat(value));
            return "ok";
        }

        function raise() {
            root.adjustVolume(0.05);
        }

        function lower() {
            root.adjustVolume(-0.05);
        }

        function muteToggle() {
            root.toggleMute();
        }

        function status(): string {
            return JSON.stringify({
                volume: root.volume,
                muted: root.muted,
                sink: root.name
            });
        }
    }
}
