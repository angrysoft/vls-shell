import QtQuick
import Quickshell
import qs.theme

Item {
    id: hint
    property string text: ""
    
    HoverHandler {
            id: hoverHandler
            parent: hint.parent
    }


    PopupWindow {
        id: hintPopup
        visible: hoverHandler.hovered
        implicitWidth: hintBackground.implicitWidth
        implicitHeight: hintBackground.implicitHeight
        anchor.item: hint.parent
        anchor.edges: Edges.Bottom | Edges.Left
        anchor.gravity: Edges.Bottom | Edges.Right

        color: "transparent"

        Rectangle {
            id: hintBackground
            anchors.fill: parent
            implicitWidth: hintText.implicitWidth + Theme.style.padding * 2
            implicitHeight: hintText.implicitHeight + Theme.style.padding * 2
            color: Theme.colors.surface
            border.color: Theme.colors.outline
            border.width: 1
            radius: Theme.style.borderRadius
            opacity: 0

            states: State {
                name: "visible"
                when: hoverHandler.hovered
                PropertyChanges { target: hintBackground; opacity: 1 }
            }

            transitions: [
                Transition {
                    from: ""; to: "visible"
                    NumberAnimation { property: "opacity"; duration: 500; easing.type: Easing.OutCubic }
                },
                Transition {
                    from: "visible"; to: ""
                    NumberAnimation { property: "opacity"; duration: 500; easing.type: Easing.InCubic }
                }
            ]

            Text {
                id: hintText
                anchors.centerIn: parent
                text: hint.text
                color: Theme.colors.on_surface
                font.pixelSize: Theme.style.fontSize
            }
        }
    }
}