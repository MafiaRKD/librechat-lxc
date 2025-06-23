#!/bin/bash

# LibreChat inštalačný skript pre LXC kontajner
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

info "Inštalujem závislosti..."
apt install -y curl git npm nodejs mongodb

info "Klonujem LibreChat..."
cd /opt
rm -rf librechat
git clone https://github.com/danny-avila/LibreChat.git librechat
cd librechat

info "Inštalujem npm balíky..."
npm install

info "Kopírujem konfiguračný súbor..."
cp .env.example .env

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
echo -e "📍 Webové rozhranie bude na http://IP:3080\n"
