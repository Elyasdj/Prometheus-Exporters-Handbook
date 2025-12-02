# 📊 Prometheus-Exporters-Handbook

A comprehensive production-ready guide for deploying and configuring Prometheus exporters for PostgreSQL database monitoring.

---

## 🔍 Introduction

### What is Monitoring?
Monitoring is the systematic observation and recording of system metrics to ensure reliability, performance, and availability of services.

### What are Metrics?
Numerical measurements collected over time that represent the state and performance of a system.

### Use Cases
- Performance tracking and optimization
- Incident detection and alerting
- Capacity planning and resource management
- SLA compliance verification
- Root cause analysis

---

## 🚀 Installation & Configuration

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-v18-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![PostgreSQL Exporter](https://img.shields.io/badge/PostgreSQL_Exporter-v0.18.1-orange?logo=prometheus)](https://github.com/prometheus-community/postgres_exporter)

### 1. PostgreSQL Exporter

**Default Port**: `9187`

#### What is PostgreSQL Exporter?
A Prometheus exporter that collects and exposes PostgreSQL database metrics including connection stats, query performance, replication status, and table statistics.

#### Binary Installation Steps (RH/DEB)

```bash
# Download PostgreSQL Exporter
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.18.1/postgres_exporter-0.18.1.linux-amd64.tar.gz
tar -xvf postgres_exporter-0.18.1.linux-amd64.tar.gz

# Create user
sudo useradd -rs /sbin/nologin exporter

# Install binary
cd postgres_exporter-0.18.1.linux-amd64
sudo mv postgres_exporter /usr/local/bin
sudo chown exporter. /usr/local/bin/postgres_exporter
sudo chmod 755 /usr/local/bin/postgres_exporter

# Create systemd service
sudo vim /usr/lib/systemd/system/postgresql_exporter.service
# For Debian Distro Use This Path /lib/systemd/system/postgresql_exporter.service

# Configure firewall
sudo firewall-cmd --add-port=9187/tcp --permanent
sudo firewall-cmd --reload

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable --now postgres_exporter.service
```

#### Verification
```bash
sudo systemctl status postgres_exporter.service
sudo ss -tunpla | grep 9187
```

#### Access
`http://localhost:9187/metrics` or `http://your-ip:9187/metrics`

#### Test Metrics
```bash
curl http://localhost:9187/metrics
```
#### Grafana Dashboard
📦 [Grafana/Dashboards](https://grafana.com/grafana/dashboards/9628-postgresql-database/)


#### Official Repository
📦 [Prometheus/Postgres_Exporter](https://github.com/prometheus-community/postgres_exporter?tab=readme-ov-file)

---

<div align="center">
  <sub>Created with by Elyasdj</sub>
</div>
