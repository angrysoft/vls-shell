#!/usr/bin/bash
# generate_translations.sh

# 1. Skanuj wszystkie pliki .qml i zaktualizuj plik .ts dla języka polskiego
lupdate6 . -recursive -ts translations/pl_PL.ts

# 2. Skompiluj plik .ts do produkcyjnego .qm
lrelease6 translations/pl_PL.ts -qm i18n/pl_PL.qm

echo "Tłumaczenia zostały zaktualizowane i skompilowane!"