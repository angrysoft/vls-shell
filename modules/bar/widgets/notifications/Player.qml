pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.theme
import qs.components
import qs.services

ClippingRectangle {
    id: playerView
    required property MprisPlayer player

    Layout.fillWidth: true
    Layout.preferredHeight: content.implicitHeight
    Layout.margins: Theme.style.dialogPadding
    radius: Theme.style.dialogRadius
    color: Theme.colors.surface_container

    RowLayout {
        id: content
        anchors.fill: parent
        spacing: Theme.style.spacing * 2

        Image {
            visible: playerView.player.trackArtUrl !== ""
            source: playerView.player.trackArtUrl
            Layout.preferredHeight: parent.implicitHeight
            Layout.preferredWidth: parent.implicitHeight
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            fillMode: Image.PreserveAspectCrop
            sourceSize: Qt.size(200, 200)
            asynchronous: true
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignCenter
            Layout.margins: Theme.style.dialogPadding
            spacing: Theme.style.spacing

            TextLabel {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: playerView.player.trackTitle
                color: Theme.colors.on_surface
                font.bold: true
                maximumLineCount: 1
                Layout.preferredWidth: parent.implicitWidth
            }
            TextLabel {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                visible: playerView.player.trackArtist !== ""
                text: playerView.player.trackArtist.replace(/&(?!amp;|lt;|gt;|quot;|apos;|#\d+;|#x[0-9a-fA-F]+;)/g, "&amp;")
                color: Theme.colors.on_surface_variant
                maximumLineCount: 3
                Layout.preferredWidth: parent.implicitWidth
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.style.spacing
                property bool isPlaying: playerView.player.playbackState === MprisPlaybackState.Playing

                Button {
                    text: ""
                    icon.name: "media-skip-backward-symbolic"
                    icon.width: 20
                    icon.height: 20
                    icon.color: Theme.colors.on_surface
                    background: Rectangle {
                        color: "transparent"
                    }
                    enabled: playerView.player.canPlay
                    onClicked: playerView.player.previous()
                }

                Button {
                    text: ""
                    icon.name: playerView.player.playbackState === MprisPlaybackState.Playing ? "media-playback-pause-symbolic" : "media-playback-start-symbolic"
                    icon.width: 20
                    icon.height: 20
                    icon.color: Theme.colors.on_surface
                    background: Rectangle {
                        color: "transparent"
                    }
                    enabled: playerView.player.canPlay
                    onClicked: playerView.player.togglePlaying()
                }

                Button {
                    text: ""
                    icon.name: "media-skip-forward-symbolic"
                    icon.width: 20
                    icon.height: 20
                    icon.color: Theme.colors.on_surface
                    background: Rectangle {
                        color: "transparent"
                    }
                    enabled: playerView.player.canPlay
                    onClicked: playerView.player.next()
                }
            }
        }
    }
}
