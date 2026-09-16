import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import qs.theme

TextField {
    padding: Theme.style.padding
    font.pixelSize: Theme.style.fontSize
    focus: true
    color: Theme.colors.on_surface
    placeholderTextColor: Theme.colors.outline
    Material.accent: Theme.colors.primary
    Material.foreground: Theme.colors.on_surface
}
