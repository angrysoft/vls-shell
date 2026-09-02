import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import qs.theme


Item {
    id: root
    property SystemTrayItem item
    implicitWidth: parent.height
    implicitHeight: parent.height
    // acceptedButtons: Qt.LeftButton | Qt.RightButton

    QsMenuAnchor {
                id: menuAnchor
                menu: root.item.menu
                anchor.item: root
                anchor.edges: Edges.Bottom | Edges.Left
                anchor.gravity: Edges.Bottom | Edges.Left
    }

    TapHandler {
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onTapped:(eventPoint, button) => {
           switch (button) {
                case Qt.LeftButton:
                    item.activate();
                    break;
                case Qt.RightButton:
                    if (item.hasMenu) {
                        menuAnchor.open();
                    }
                    break;
                }
        }
    }
    
    IconImage {
        id: trayIcon
        anchors.centerIn: parent
        source: root.item.icon
        implicitSize: parent.height
        smooth: true
    }
}
