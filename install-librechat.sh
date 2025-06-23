#!/bin/bash

# LibreChat inštalačný skript pre LXC kontajner
# Upravené: MafiaRKD, 2025-06
# Repo: https://github.com/MafiaRKD/librechat-lxc

set -e

green='\033[0;32m'
red='\033[0;31m'
clear='\033[0m'

info() {
  echo -e "${green}[INFO]${clear} $1"
}

error() {
  echo -e "${red}[ERROR]${clear} $1" >&2
}

info "Aktualizujem systém..."
apt update && apt upgrade -y

info "Inštalujem základné závislosti..."
apt install -y curl gnupg git ca-certificates

info "Pridávam Node.js 20 repozitár..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

info "Pridávam MongoDB 7 repozitár..."
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
echo "deb [signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list

apt update
info "Inštalujem MongoDB 7..."
apt install -y mongodb-org
systemctl enable mongod
systemctl start mongod

info "Klonujem LibreChat..."
cd /opt
rm -rf librechat
git clone https://github.com/danny-avila/LibreChat.git librechat
cd librechat

info "Inštalujem npm balíky..."
npm install

info "Kopírujem konfiguračný súbor..."
cp .env.example .env

info "Upravujem port v .env na 8080..."
sed -i 's/^PORT=.*/PORT=8080/' .env

info "Vytváram systemd službu..."
cat <<EOF > /etc/systemd/system/librechat.service
[Unit]
Description=LibreChat Server
After=network.target mongod.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/librechat
ExecStart=/usr/bin/npm start
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl enable librechat
systemctl start librechat

info "Hotovo!"
echo -e "\n${green}🔑 Nezabudni pridať svoj OpenAI API key do súboru .env v /opt/librechat${clear}"
echo -e "Príklad:\n\nOPENAI_API_KEY=sk-xxxx...\n"
echo -e "📍 Webové rozhranie bude na http://IP:8080\n"
