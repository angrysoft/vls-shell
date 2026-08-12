pragma Singleton
import QtQuick

QtObject {
    property bool controlCenterOpen: false

    function toggleControlCenter() {
        controlCenterOpen = !controlCenterOpen;
    }
}