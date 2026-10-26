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
			property string background: "#19120c"
			property string error: "#ffece9"
			property string error_container: "#ffaea4"
			property string inverse_on_surface: "#000000"
			property string inverse_primary: "#6c3c03"
			property string inverse_surface: "#efe0d5"
			property string on_background: "#efe0d5"
			property string on_error: "#000000"
			property string on_error_container: "#000000"
			property string on_primary: "#000000"
			property string on_primary_container: "#000000"
			property string on_primary_fixed: "#000000"
			property string on_primary_fixed_variant: "#1e0d00"
			property string on_secondary: "#000000"
			property string on_secondary_container: "#000000"
			property string on_secondary_fixed: "#000000"
			property string on_secondary_fixed_variant: "#1d0d01"
			property string on_surface: "#ffffff"
			property string on_surface_variant: "#ffffff"
			property string on_tertiary: "#000000"
			property string on_tertiary_container: "#000000"
			property string on_tertiary_fixed: "#000000"
			property string on_tertiary_fixed_variant: "#0e1300"
			property string outline: "#ffede0"
			property string outline_variant: "#d1bfb2"
			property string primary: "#ffede0"
			property string primary_container: "#fab473"
			property string primary_fixed: "#ffdcc0"
			property string primary_fixed_dim: "#feb877"
			property string scrim: "#000000"
			property string secondary: "#ffede0"
			property string secondary_container: "#debca1"
			property string secondary_fixed: "#ffdcc0"
			property string secondary_fixed_dim: "#e2c0a5"
			property string shadow: "#000000"
			property string surface: "#19120c"
			property string surface_bright: "#584e46"
			property string surface_container: "#372f28"
			property string surface_container_high: "#433a32"
			property string surface_container_highest: "#4f453d"
			property string surface_container_low: "#261e18"
			property string surface_container_lowest: "#000000"
			property string surface_dim: "#19120c"
			property string surface_tint: "#feb877"
			property string surface_variant: "#51443a"
			property string tertiary: "#ebf5bf"
			property string tertiary_container: "#bec895"
			property string tertiary_fixed: "#dee8b3"
			property string tertiary_fixed_dim: "#c2cc98"
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
			property int fontSize: 16
			property int barHeight: 36
			property int borderRadius: 4
			property int dialogRadius: 16
			property int dialogPadding: 16
			property int borderWidth: 1
			property string barBackgroundColor: "transparent"
			property int margin: 8
			property int padding: 4
			property int spacing: 8
		}
	}
	
}
