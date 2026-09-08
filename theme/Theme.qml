pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	property alias colors: colors
    
	FileView {
			path: `${Quickshell.env("HOME")}/.config/vls-shell/colors.json`
			watchChanges: true
			onFileChanged: reload()

		JsonAdapter {
			id: colors
			property string background: "transparent"
			property string error: "transparent"
			property string error_container: "transparent"
			property string inverse_on_surface: "transparent"
			property string inverse_primary: "transparent"
			property string inverse_surface: "transparent"
			property string on_background: "transparent"
			property string on_error: "transparent"
			property string on_error_container: "transparent"
			property string on_primary: "transparent"
			property string on_primary_container: "transparent"
			property string on_primary_fixed: "transparent"
			property string on_primary_fixed_variant: "transparent"
			property string on_secondary: "transparent"
			property string on_secondary_container: "transparent"
			property string on_secondary_fixed: "transparent"
			property string on_secondary_fixed_variant: "transparent"
			property string on_surface: "transparent"
			property string on_surface_variant: "transparent"
			property string on_tertiary: "transparent"
			property string on_tertiary_container: "transparent"
			property string on_tertiary_fixed: "transparent"
			property string on_tertiary_fixed_variant: "transparent"
			property string outline: "transparent"
			property string outline_variant: "transparent"
			property string primary: "transparent"
			property string primary_container: "transparent"
			property string primary_fixed: "transparent"
			property string primary_fixed_dim: "transparent"
			property string scrim: "transparent"
			property string secondary: "transparent"
			property string secondary_container: "transparent"
			property string secondary_fixed: "transparent"
			property string secondary_fixed_dim: "transparent"
			property string shadow: "transparent"
			property string surface: "transparent"
			property string surface_bright: "transparent"
			property string surface_container: "transparent"
			property string surface_container_high: "transparent"
			property string surface_container_highest: "transparent"
			property string surface_container_low: "transparent"
			property string surface_container_lowest: "transparent"
			property string surface_dim: "transparent"
			property string surface_tint: "transparent"
			property string surface_variant: "transparent"
			property string tertiary: "transparent"
			property string tertiary_container: "transparent"
			property string tertiary_fixed: "transparent"
			property string tertiary_fixed_dim: "transparent"
		}

		
	}

	property alias style: style

	FileView {
		path: `${Quickshell.env("HOME")}/.config/vls-shell/style.json`
		watchChanges: true
		onFileChanged: reload()

		JsonAdapter {
			id: style
			property string fontFamily: "JetBrains Mono"
			property int fontSize: 13
			property int barHeight: 40
			property int borderRadius: 8
			property int dialogRadius: 16
			property int dialogPadding: 16
			property int borderWidth: 1
			property string barBackgroundColor: "transparent"
			property int margin: 8
			property int padding: 8
			property int spacing: 6
		}
	}
	
}