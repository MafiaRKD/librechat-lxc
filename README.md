📦 LibreChat LXC

Automatizovaný skript pre nasadenie LibreChat s OpenAI GPT-4o v LXC kontajneri na Proxmoxe.
🚀 Inštalácia

Vytvor Debian LXC kontajner cez komunitný skript:

    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/debian.sh)"

Spusti inštaláciu LibreChat vo vnútri kontajnera:

    wget https://raw.githubusercontent.com/MafiaRKD/librechat-lxc/main/install-librechat.sh
    chmod +x install-librechat.sh
    ./install-librechat.sh

🔐 OpenAI API kľúč

Po inštalácii uprav .env súbor:

    nano /opt/librechat/.env

A pridaj svoj OpenAI kľúč:

    OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxx

🌐 Prístup

LibreChat bude dostupný na adrese:

http://<IP_adresa_kontajnera>:3080

⚙️ Čo skript robí

Inštaluje:

Node.js 20

MongoDB 7

Sťahuje a konfiguruje LibreChat

Pripraví .env súbor (bez kľúča)

Vytvorí systemd službu pre automatické spustenie po reštarte

ℹ️ Poznámka

Tento skript neobsahuje žiadne API kľúče – každý používateľ si ich musí doplniť sám do .env.
