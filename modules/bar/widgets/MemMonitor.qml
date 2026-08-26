import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import qs.components
import qs.theme

Row {
    spacing: Theme.style.spacing
    anchors.verticalCenter: parent.verticalCenter
    property real memUsagePercent: 0.0
    property real usedGiB: 0.0
    property real totalGiB: 0.0

    // FileView wczytuje i śledzi zawartość pliku
    FileView {
        id: meminfoFile
        path: "/proc/meminfo"
    }

    // Timer wymusza odświeżenie pliku co 2 sekundy
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            meminfoFile.reload();

            var content = meminfoFile.text();
            var lines = content.split("\n");

            var memTotal = 0;
            var memAvailable = 0;

            for (var i = 0; i < lines.length; i++) {
                var line = lines[i];
                if (line.startsWith("MemTotal:")) {
                    memTotal = parseInt(line.replace(/[^0-9]/g, "")) || 0;
                } else if (line.startsWith("MemAvailable:")) {
                    memAvailable = parseInt(line.replace(/[^0-9]/g, "")) || 0;
                }
                
                if (memTotal > 0 && memAvailable > 0) break;
            }

            if (memTotal > 0) {
                var memUsed = memTotal - memAvailable;
                usedGiB = memUsed / 1024 / 1024;
                totalGiB = memTotal / 1024 / 1024;
                memUsagePercent = (memUsed / memTotal) * 100;
            }
        }
    }

    IconImage {
        id: memIcon
        implicitSize: Theme.style.barHeight - Theme.style.padding * 4
        anchors.verticalCenter: parent.verticalCenter
        source: Quickshell.iconPath("memory", "ram")
        smooth: true
    }

    TextLabel {
        text: usedGiB.toFixed(1) + " / " + totalGiB.toFixed(1) + " GiB (" + memUsagePercent.toFixed(0) + "%)"
        bold: true
    }
}