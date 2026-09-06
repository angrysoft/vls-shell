# Nazwa pliku wykonywalnego
BINARY_NAME=vlsmsg
# Ścieżka do głównego pliku Go
ENTRY_POINT=./utils/vlsmsg.go

.PHONY: all build clean run test

# Domyślny cel
all: build

# Kompilacja aplikacji
build:
	go build -o $(BINARY_NAME) $(ENTRY_POINT)

# Uruchomienie aplikacji bez wcześniejszego zapisywania pliku binarnego
run:
	go run $(ENTRY_POINT)

# Czyszczenie zbudowanych plików
clean:
	go clean
	rm -f $(BINARY_NAME)

# Uruchomienie testów w projekcie
test:
	go test ./...