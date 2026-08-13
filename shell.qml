//@ pragma ShellId vls-shell
//@ pragma UseQApplication
//@ pragma IconTheme Papirus

import QtQuick
import Quickshell
import qs.config
import qs.modules.bar
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
}
