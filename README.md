# librechat-lxc
Automatizovaný skript pre nasadenie LibreChat s OpenAI GPT-4o v LXC kontajneri na Proxmoxe.

LibreChat v LXC (Proxmox)

Skript na jednoduché nasadenie LibreChat s GPT-4o cez OpenAI API v Debian LXC kontajneri na Proxmoxe.

✅ Inštalácia:

Vytvor Debian LXC cez komunitný skript:

    bash -c "$(wget -qLO - https://github.com/tteck/Proxmox/raw/main/ct/debian.sh)"

Prihlás sa do kontajnera a spusti:

    wget https://raw.githubusercontent.com/<tvoje-meno>/librechat-lxc/main/install-librechat.sh
    chmod +x install-librechat.sh
    ./install-librechat.sh
## ⚠️ Bezpečnosť

Tento skript **neobsahuje** žiadne API kľúče. Po inštalácii si musíš **manuálne upraviť** `.env` súbor v `/opt/librechat` a pridať tam:

    ```env
    OPENAI_API_KEY=sk-xxxxxx

LibreChat beží na http://<ip-kontajnera>:3080

🔧 Obsah skriptu:
Inštaluje Node.js 20, MongoDB 7
Sťahuje LibreChat a konfiguruje .env
Spúšťa ho na porte 3080
