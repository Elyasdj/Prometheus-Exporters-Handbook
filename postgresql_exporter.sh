#!/bin/bash
set -e

ARCHIVE="postgres_exporter-0.18.1.linux-amd64.tar.gz"
DIR="postgres_exporter-0.18.1.linux-amd64"
BIN_PATH="/usr/local/bin/postgres_exporter"
CONF_DIR="/etc/postgres_exporter"
SERVICE_FILE="/usr/lib/systemd/system/postgre_exporter.service"

echo "==> Checking archive..."
[ -f "$ARCHIVE" ] || { echo "Archive not found"; exit 1; }

echo "==> Extracting..."
tar -xvf "$ARCHIVE"

echo "==> Creating user..."
id pg_exporter &>/dev/null || useradd -rs /sbin/nologin pg_exporter

echo "==> Installing binary..."
mv "$DIR/postgres_exporter" "$BIN_PATH"
chown pg_exporter:pg_exporter "$BIN_PATH"
chmod 755 "$BIN_PATH"

echo "==> Creating config directory..."
mkdir -p "$CONF_DIR"

echo "==> Writing postgres_exporter.yml..."
cat > "$CONF_DIR/postgres_exporter.yml" <<EOF
auth_modules:
  foo1:
    type: userpass
    userpass:
      username: dbreader
      password: fW8bDniM8xvo25yM6x
    options:
      sslmode: disable
EOF

chown -R pg_exporter:pg_exporter "$CONF_DIR"
chmod 640 "$CONF_DIR/postgres_exporter.yml"

echo "==> Writing systemd service..."
cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Postgres_Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=pg_exporter
Group=pg_exporter
Type=simple
Restart=on-failure
RestartSec=5
Environment="DATA_SOURCE_NAME=postgresql://dbreader1:123456@localhost:5432/postgres?sslmode=disable"
ExecStart=/usr/local/bin/postgres_exporter \\
  --config.file="/etc/postgres_exporter/postgres_exporter.yml" \\
  --web.listen-address=":9187" \\
  --web.telemetry-path="/metrics" \\
  --collector.database_wraparound \\
  --collector.long_running_transactions \\
  --collector.postmaster \\
  --collector.process_idle \\
  --collector.stat_activity_autovacuum \\
  --collector.stat_statements \\
  --collector.stat_statements.include_query \\
  --collector.stat_wal_receiver \\
  --collector.statio_user_indexes \\
  --collector.xlog_location

[Install]
WantedBy=multi-user.target
EOF

echo "==> Enabling service..."
systemctl daemon-reload
systemctl enable --now postgre_exporter.service

echo "==> Cleanup..."
rm -rf "$DIR" "$ARCHIVE"

echo "==> Done!"
systemctl status postgre_exporter.service --no-pager
ss -tunpla | grep 9187 || true
