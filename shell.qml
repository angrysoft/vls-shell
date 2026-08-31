//@ pragma ShellId vls-shell
//@ pragma UseQApplication
//@ pragma IconTheme Papirus
//@ pragma NativeTextRendering

import QtQuick
import Quickshell
import Quickshell.Io
import qs.config
import qs.modules.bar
import qs.modules.launcher
import qs.modules.wallpaper


ShellRoot {
    LazyLoader {
        active: Config.modules.bar.enabled
        component: Bar {}
    }

    LazyLoader {
        active: Config.modules.wallpaper.enabled
        component: Wallpaper {}
    }

    Launcher {}

    // Component.onCompleted: {
    //     // 1. Odczytaj zmienną LANG z systemu
    //     let langEnv = Quickshell.env("LANG") ?? "en_US";
        
    //     // 2. Wyciągnij sam kod języka (np. z "pl_PL.UTF-8" wyciągnij "pl_PL")
    //     let sysLang = langEnv.split(".")[0];

    //     console.log("Wykryto język systemowy z LANG:", sysLang, langEnv);

    //     // 3. Ustaw Qt.uiLanguage - to powiadomi wszystkie qsTr() w QML
    //     I18n.locale = sysLang;
    //     Qt.uiLanguage = sysLang;
    // }
}
