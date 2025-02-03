#!/bin/bash

# Configurazione utente per i commit
git config --global user.name "nomeutente"
git config --global user.email "nomeutente@example.com"  # Sostituisci con il tuo indirizzo email

# Aggiungi il remote upstream se non esiste
git remote get-url upstream || git remote add upstream https://github.com/UrloMythus/MammaMia.git

# Sincronizziamo il fork con upstream
echo "Sincronizzando il fork con upstream..."
git fetch upstream

# Backup dei file specifici
backup_dir="backup_files"
echo "Creazione della directory di backup..."
mkdir -p "$backup_dir"
cp config.json "$backup_dir/config.json"
cp render.yaml "$backup_dir/render.yaml"
cp Dockerfiles/Dockerfile-auto-update-no-config "$backup_dir/Dockerfile-auto-update-no-config"

echo "Eseguendo il merge dal repository upstream..."
git checkout main
git merge upstream/main --allow-unrelated-histories || echo "Nessuna modifica da applicare."

# Ripristino dei file specifici dal backup
echo "Ripristino dei file specifici dal backup..."
cp "$backup_dir/config.json" config.json
cp "$backup_dir/render.yaml" render.yaml
cp "$backup_dir/Dockerfile-auto-update-no-config" Dockerfiles/Dockerfile-auto-update-no-config

# Aggiungiamo le modifiche al commit
echo "Aggiungendo modifiche al commit..."
git add .

# Commettiamo le modifiche
echo "Commettendo le modifiche..."
git commit -m "Sincronizzazione del fork con upstream e aggiornamento dei file"

# Pushing delle modifiche nel fork
echo "Pushing changes to the fork..."
git push origin main

# Pulizia della directory di backup
echo "Pulizia dei file di backup..."
rm -rf "$backup_dir"

echo "Operazione completata!"
