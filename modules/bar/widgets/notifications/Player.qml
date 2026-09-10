pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Mpris
import qs.theme
// import qs.components
import qs.services

Item {
    id: playerView
    required property MprisPlayer player

    implicitHeight: contentWrapper.implicitHeight
    Layout.fillWidth: true
    Layout.margins: Theme.style.dialogPadding


    Rectangle {
        id: contentWrapper
        width: parent.width
        radius: Theme.style.dialogRadius
        color: Theme.colors.surface_container

        implicitHeight: content.implicitHeight

        RowLayout {
            id: content
            spacing: Theme.style.spacing

            Image {
                visible: playerView.player.trackArtUrl !== ""
                source: playerView.player.trackArtUrl
                // Layout.preferredWidth:
                Layout.margins: Theme.style.dialogPadding

                Layout.preferredHeight: 100
                fillMode: Image.PreserveAspectFit
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: Theme.style.spacing

                Text {
                    text: playerView.player.trackTitle
                    color: Theme.colors.on_surface
                    font.bold: true
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }
                Text {
                    visible: playerView.player.trackArtist !== ""
                    text: playerView.player.trackArtist.replace(/&(?!amp;|lt;|gt;|quot;|apos;|#\d+;|#x[0-9a-fA-F]+;)/g, "&amp;")
                    color: Theme.colors.on_surface_variant
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                    maximumLineCount: 3
                    elide: Text.ElideRight
                    textFormat: Text.StyledText 
                }

                RowLayout {
                    spacing: Theme.style.spacing
                    property bool isPlaying: playerView.player.playbackState === MprisPlaybackState.Playing

                    Button {
                        text: ""
                        icon.name: "media-skip-backward-symbolic"
                        icon.width: 20
                        icon.height: 20
                        icon.color: Theme.colors.on_surface_container
                        background: Rectangle {
                            color: "transparent"
                        }
                        enabled: playerView.player.canPlay
                        onClicked: playerView.player.previous()
                    }

                    Button {
                        text: ""
                        implicitWidth: 40
                        implicitHeight: 40
                        icon.name: playerView.player.playbackState === MprisPlaybackState.Playing ? "media-playback-pause-symbolic" : "media-playback-start-symbolic"
                        icon.width: 20
                        icon.height: 20
                        icon.color: Theme.colors.on_surface_container
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
                        icon.color: Theme.colors.on_surface_container
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
}
