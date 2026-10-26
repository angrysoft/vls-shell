PREFIX ?= /usr
BINDIR ?= $(PREFIX)/bin
DATADIR ?= $(PREFIX)/share
LIBDIR ?= $(PREFIX)/lib

INSTALL_DIR = $(DESTDIR)$(DATADIR)/vls-shell
INSTALL_SYSTEMD_USER = $(DESTDIR)$(LIBDIR)/systemd/user
INSTALL_PRESET = $(DESTDIR)$(LIBDIR)/systemd/user-preset
BINARY_NAME=vlsmsg
SRC_DIR=./utils

.PHONY: all build clean run test

# Domyślny cel
all: build

# Kompilacja aplikacji
build:
	go build -o $(BINARY_NAME) $(SRC_DIR)/vlsmsg.go

# Uruchomienie aplikacji bez wcześniejszego zapisywania pliku binarnego
run:
	go run $(SRC_DIR)/vlsmsg.go

# Czyszczenie zbudowanych plików
clean:
	go clean
	rm -f ${SRC_DIR}/$(BINARY_NAME)

install:
	# vlsmsg binary installation
	install -d ${BINDIR}
	install -m 0755 ${SRC_DIR}/$(BINARY_NAME) ${DESTDIR}${BINDIR}
	
	# shell installation
	install -d ${INSTALL_DIR}
	cp -r app components config i18n modules services theme shell.qml $(INSTALL_DIR)/
	
	# systemd
# 	install -d ${INSTALL_SYSTEMD_USER}
# 	install -d ${INSTALL_PRESET}
# 	install -m 0644 systemd/vls-shell.service ${INSTALL_SYSTEMD_USER}
# 	echo "enable vls-shell.service" > $(INSTALL_PRESET)/50-vls-shell.preset
 	#install -m 0644 systemd/*.timer ${INSTALL_SYSTEMD_USER}
	
	# helpers (desktop entries)
	install -d ${DESTDIR}$(DATADIR)/applications/
	install -m 0644 ${SRC_DIR}/poweroff.desktop ${DESTDIR}$(DATADIR)/applications/
	install -m 0644 ${SRC_DIR}/reboot.desktop ${DESTDIR}$(DATADIR)/applications/

# Uruchomienie testów w projekcie
test:
	go test ./...