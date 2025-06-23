#!/bin/bash

### === KONFIGURÁCIA === ###
OPENAI_API_KEY="sk-SEM_DAJ_SVOJ_KLUC"
INSTALL_DIR="/opt/librechat"
LIBRECHAT_PORT="3080"

### === UPDATE SYSTÉMU === ###
echo "[1/7] Aktualizujem systém..."
apt update && apt upgrade -y

### === NODE.JS === ###
echo "[2/7] Inštalujem Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

### === MONGODB === ###
echo "[3/7] Inštalujem MongoDB..."
apt install -y gnupg curl software-properties-common
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
echo "deb [signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" > /etc/apt/sources.list.d/mongodb-org-7.0.list
apt update && apt install -y mongodb-org
systemctl enable mongod
systemctl start mongod

### === LIBRECHAT === ###
echo "[4/7] Sťahujem LibreChat..."
git clone https://github.com/danny-avila/LibreChat.git "$INSTALL_DIR"
cd "$INSTALL_DIR"
npm install

### === KONFIGURÁCIA .env === ###
echo "[5/7] Nastavujem .env..."
cp .env.example .env

sed -i "s|OPENAI_API_KEY=.*|OPENAI_API_KEY=$OPENAI_API_KEY|" .env
sed -i "s|MONGO_URI=.*|MONGO_URI=mongodb://localhost:27017/LibreChat|" .env
sed -i "s|DEFAULT_MODEL=.*|DEFAULT_MODEL=gpt-4o|" .env
sed -i "s|PORT=.*|PORT=$LIBRECHAT_PORT|" .env

### === ŠTART APPKY === ###
echo "[6/7] Spúšťam LibreChat..."
npm run build
npm run start &

echo "[7/7] Hotovo!"
echo ""
echo "🔗 Otvor si LibreChat na: http://<IP_TVOJHO_LXC>:${LIBRECHAT_PORT}"
echo "Ak potrebuješ reverzný proxy, viem ti s tým pomôcť 😉"
