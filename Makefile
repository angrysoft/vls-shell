PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share
LIBDIR ?= $(PREFIX)/lib

INSTALL_DIR = $(DESTDIR)$(DATADIR)/vls-shell
INSTALL_SYSTEMD_USER = $(DESTDIR)$(LIBDIR)/systemd/user
INSTALL_PRESET = $(DESTDIR)$(LIBDIR)/systemd/user-preset
BINARY_NAME=vlsmsg
SRC_DIR=./utils/vlsmsg
OUT_DIR=./bin
.PHONY: all build clean run test

# Domyślny cel
all: build

# Kompilacja aplikacji
build:
	@mkdir -p $(OUT_DIR)
	go build -o $(OUT_DIR)/$(BINARY_NAME) $(SRC_DIR)/vlsmsg.go

# Uruchomienie aplikacji bez wcześniejszego zapisywania pliku binarnego
run:
	go run $(SRC_DIR)/vlsmsg.go

# Czyszczenie zbudowanych plików
clean:
	@go clean
	@rm -rvf ${OUT_DIR}

install:
	# vlsmsg binary installation
	install -d ${DESTDIR}${BINDIR}
	install -m 0755 ${OUT_DIR}/$(BINARY_NAME) ${DESTDIR}${BINDIR}
	
	# shell installation
	install -d ${INSTALL_DIR}
	@cp -rv app components config i18n modules services theme shell.qml $(INSTALL_DIR)/
	
	# helpers (desktop entries)
	install -d ${DESTDIR}$(DATADIR)/applications/
	install -m 0644 poweroff.desktop ${DESTDIR}$(DATADIR)/applications/
	install -m 0644 reboot.desktop ${DESTDIR}$(DATADIR)/applications/
	# wallpaper
	install -D -m 0644 veles-wallpaper-4k.png ${DESTDIR}$(DATADIR)/wallpapers/veles-wallpaper-4k.png

# Uruchomienie testów w projekcie
test:
	go test ./...