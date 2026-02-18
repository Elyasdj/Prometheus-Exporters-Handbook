#!/bin/bash
set -e

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
NC="\e[0m"

USER="pg_exporter"
BIN_PATH="/usr/local/bin/postgres_exporter"
CONF_DIR="/etc/postgres_exporter"
SERVICE_FILE="/usr/lib/systemd/system/postgres_exporter.service"
SCRIPT_NAME=$(basename "$0")

echo -e "${BLUE}=========================================${NC}"
echo -e "${BLUE} 🚀 Offline Postgres Exporter Installer  ${NC}"
echo -e "${BLUE}=========================================${NC}"

#########################################
#        Find archive dynamically       #
#########################################

ARCHIVE=$(ls postgres_exporter-*.linux-*.tar.gz 2>/dev/null | head -n1)

if [[ -z "$ARCHIVE" ]]; then
    echo -e "${RED}❌ Archive not found${NC}"
    echo -e "${YELLOW}Expected: postgres_exporter-<version>.linux-<arch>.tar.gz${NC}"
    exit 1
fi

VERSION=$(echo "$ARCHIVE" | sed -E 's/postgres_exporter-([0-9.]+)\.linux-.*/\1/')
ARCH=$(echo "$ARCHIVE" | sed -E 's/.*\.linux-([^.]+)\.tar\.gz/\1/')
DIR="postgres_exporter-${VERSION}.linux-${ARCH}"

echo -e "${GREEN}✅ Found archive: $ARCHIVE${NC}"
echo -e "${GREEN}📦 Version: $VERSION${NC}"
echo -e "${GREEN}🖥 Arch:    $ARCH${NC}"

#########################################
#               Extract                 #
#########################################

echo -e "${BLUE}📂 Extracting archive...${NC}"
tar -xvf "$ARCHIVE" >/dev/null
echo -e "${GREEN}✅ Extracted${NC}"

#########################################
#             Create user               #
#########################################

echo -e "${BLUE}👤 Creating user: $USER${NC}"
if ! id $USER &>/dev/null; then
    useradd -rs /sbin/nologin $USER
    echo -e "${GREEN}✅ User created${NC}"
else
    echo -e "${YELLOW}⚠️ User already exists${NC}"
fi

#########################################
#           Install binary              #
#########################################

echo -e "${BLUE}⚙️ Installing binary...${NC}"
mkdir -p "$(dirname "$BIN_PATH")"

if [[ ! -f "$DIR/postgres_exporter" ]]; then
    echo -e "${RED}❌ Binary not found in extracted directory${NC}"
    exit 1
fi

mv "$DIR/postgres_exporter" "$BIN_PATH"
chown $USER:$USER "$BIN_PATH"
chmod 755 "$BIN_PATH"
echo -e "${GREEN}✅ Binary installed at $BIN_PATH${NC}"

#########################################
#           Config directory            #
#########################################

echo -e "${BLUE}📝 Creating config directory...${NC}"
mkdir -p "$CONF_DIR"

cat > "$CONF_DIR/postgres_exporter.yml" <<EOF
auth_modules:
  default:
    type: userpass
    userpass:
      username: dbreader
      password: fW8bDniM8xvo25yM6x
    options:
      sslmode: disable
EOF

chown -R $USER:$USER "$CONF_DIR"
chmod 640 "$CONF_DIR/postgres_exporter.yml"
echo -e "${GREEN}✅ Config written${NC}"

#########################################
#           Systemd service             #
#########################################

echo -e "${BLUE}🧩 Creating systemd service...${NC}"
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Prometheus Postgres Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=$USER
Group=$USER
Type=simple
Restart=on-failure
RestartSec=5
Environment="DATA_SOURCE_NAME=postgresql://dbreader1:123456@localhost:5432/postgres?sslmode=disable"
ExecStart=$BIN_PATH \\
  --config.file=$CONF_DIR/postgres_exporter.yml \\
  --web.listen-address=:9187

[Install]
WantedBy=multi-user.target
EOF

echo -e "${GREEN}✅ Service created${NC}"

#########################################
#             Start service             #
#########################################

echo -e "${BLUE}🔄 Reloading systemd...${NC}"
systemctl daemon-reload

echo -e "${BLUE}▶️ Enabling & starting service...${NC}"
systemctl enable --now postgres_exporter

#########################################
#             Verification              #
#########################################

echo -e "${BLUE}🔍 Verifying...${NC}"

systemctl is-active --quiet postgres_exporter && \
echo -e "${GREEN}✅ SERVICE: UP${NC}" || \
echo -e "${RED}❌ SERVICE: DOWN${NC}"

ss -tunlp | grep -q ":9187" && \
echo -e "${GREEN}✅ PORT 9187: LISTENING${NC}" || \
echo -e "${RED}❌ PORT 9187: NOT LISTENING${NC}"

#########################################
#               Cleanup                 #
#########################################

echo -e "${BLUE}🧹 Cleaning up...${NC}"
rm -rf "$DIR" "$ARCHIVE" "$SCRIPT_NAME"
echo -e "${GREEN}✅ Cleanup completed${NC}"

echo -e "${GREEN}"
echo "====================================================================="
echo "           🎉 Postgres Exporter Installed Successfully               "
echo "====================================================================="
echo " 📦 Version: $VERSION"
echo " 🖥  Arch:    $ARCH"
echo " 👤 User:    $USER"
echo " 🌐 Metrics: http://$(hostname -I | awk '{print $1}'):9187/metrics"
echo "====================================================================="
echo -e "${NC}"
