package main

import (
	"bufio"
	"bytes"
	"encoding/binary"
	"fmt"
	"net"
	"os"
	"path/filepath"
	"strings"
	"time"
	"unicode/utf16"
)

const cmdCall = 0x03
const isVoidLabel = "IsVoid:"
const resultLabel = "Result:"
const errorLabel = "Error:"

func Call(socketPath, target, function string, args []string) (result string, isVoid bool, err error) {
	conn, err := net.DialTimeout("unix", socketPath, 2*time.Second)
	if err != nil {
		return "", false, fmt.Errorf("dial: %w", err)
	}
	defer conn.Close()
	conn.SetDeadline(time.Now().Add(2 * time.Second))

	var buf bytes.Buffer
	buf.WriteByte(cmdCall)
	writeQString(&buf, target)
	writeQString(&buf, function)
	binary.Write(&buf, binary.BigEndian, uint32(len(args)))
	for _, a := range args {
		writeQString(&buf, a)
	}
	if _, err = conn.Write(buf.Bytes()); err != nil {
		return "", false, fmt.Errorf("write: %w", err)
	}

	r := bufio.NewReader(conn)
	var status uint8
	if err = binary.Read(r, binary.BigEndian, &status); err != nil {
		return "", false, err
	}
	switch status {
	case 1:
		return "", false, fmt.Errorf("not ready")
	case 2:
		return "", false, fmt.Errorf("target not found")
	case 3:
		return "", false, fmt.Errorf("function not found")
	case 4:
		return "", false, fmt.Errorf("argument mismatch")
	case 5:
		// ok, fall through
	default:
		return "", false, fmt.Errorf("unknown response %d", status)
	}

	var voidByte uint8
	if err = binary.Read(r, binary.BigEndian, &voidByte); err != nil {
		return "", false, err
	}
	val, err := readQString(r)
	return val, voidByte != 0, err
}

func writeQString(w *bytes.Buffer, s string) {
	u16 := utf16.Encode([]rune(s))
	binary.Write(w, binary.BigEndian, uint32(len(u16)*2))
	for _, cu := range u16 {
		binary.Write(w, binary.BigEndian, cu)
	}
}

func readQString(r *bufio.Reader) (string, error) {
	var length uint32
	if err := binary.Read(r, binary.BigEndian, &length); err != nil {
		return "", err
	}
	if length == 0xFFFFFFFF {
		return "", nil
	}
	units := make([]uint16, length/2)
	for i := range units {
		if err := binary.Read(r, binary.BigEndian, &units[i]); err != nil {
			return "", err
		}
	}
	return string(utf16.Decode(units)), nil
}

func getSocketPath() (string, error) {
	runtimeDir := os.Getenv("XDG_RUNTIME_DIR")
	data, err := os.ReadFile(filepath.Join(runtimeDir, "vls-shell.pid"))
	if err != nil {
		return "", err
	}
	pid := strings.TrimSpace(string(data))
	return filepath.Join(runtimeDir, fmt.Sprintf("quickshell/by-pid/%s/ipc.sock", pid)), nil
}

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: vlsmsg <command> [args...]")
		return
	}
	command := os.Args[1]
	args := os.Args[2:]
	socketPath, err := getSocketPath()
	if err != nil {
		fmt.Println("Error getting socket path:", err)
		return
	}

	switch command {
	case "volume":
		handleVolume(socketPath, args)
	case "launcher":
		handleLauncher(socketPath, args)
	case "notification":
		handleNotification(socketPath, args)
	case "session":
		handleSession(socketPath, args)
	default:
		fmt.Println("Unknown command:", command)
	}
}

func handleLauncher(socketPath string, _ []string) {
	_, _, err := Call(socketPath, "launcher", "toggle", []string{})
	if err != nil {
		fmt.Println("Error calling launcher toggle:", err)
	}
}

func handleVolume(socketPath string, args []string) {
	cmd := ""
	switch args[0] {
	case "raise":
		cmd = "raise"
	case "lower":
		cmd = "lower"
	case "muteToggle":
		cmd = "muteToggle"
	default:
		fmt.Println("Unknown volume command:", args[0])
		return
	}
	result, isVoid, err := Call(socketPath, "volume", cmd, []string{})
	fmt.Println(resultLabel, result)
	fmt.Println(isVoidLabel, isVoid)
	fmt.Println(errorLabel, err)
}

func handleNotification(socketPath string, args []string) {
	cmd := ""
	switch args[0] {
	case "clearHistory":
		cmd = "clearHistory"
	case "markAllRead":
		cmd = "markAllRead"
	case "status":
		cmd = "status"
	default:
		fmt.Println("Unknown notification command:", args[0])
		return
	}
	result, isVoid, err := Call(socketPath, "notification", cmd, []string{})
	fmt.Println(resultLabel, result)
	fmt.Println(isVoidLabel, isVoid)
	fmt.Println(errorLabel, err)
}

func handleSession(socketPath string, args []string) {
	cmd := ""
	switch args[0] {
	case "lock":
		cmd = "lock"
	case "suspend":
		cmd = "suspend"
	case "powerOff":
		cmd = "powerOff"
	default:
		fmt.Println("Unknown session command:", args[0])
		return
	}
	result, isVoid, err := Call(socketPath, "session", cmd, []string{})
	fmt.Println(resultLabel, result)
	fmt.Println(isVoidLabel, isVoid)
	fmt.Println(errorLabel, err)
}