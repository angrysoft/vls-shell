#!/bin/sh

SHELL_DIR="/home/seba/workspace/vls-shell"

run_ipc() {
    quickshell -p "$SHELL_DIR" ipc call "$@"
}

TARGET="$1"
CMD="$2"

volume() {
    case "$CMD" in
    "raise")
            run_ipc volume raise
            ;;
    "lower")
            run_ipc volume lower
            ;;
    "muteToggle")
            run_ipc volume muteToggle
            ;;
    "status")
            run_ipc volume status
            ;;
        *)
            echo "Unknown command for volume: $CMD"
            exit 1
            ;;
    esac
}

function notifications() {
    case "$CMD" in
    "clearHistory")
            run_ipc notifications clearHistory
            ;;
    "markAllRead")
            run_ipc notifications markAllRead
            ;;
    "status")
            run_ipc notifications status
            ;;
        *)
            echo "Unknown command for notifications: $CMD"
            exit 1
            ;;
    esac
}

case "$TARGET" in
    "volume")
        volume
        ;;
    "launcher")
        run_ipc launcher toggle
        ;;
    "notifications")
        notifications
        ;;
    *)
        echo "Unknown command for target: $TARGET"
        exit 1
        ;;
esac
   