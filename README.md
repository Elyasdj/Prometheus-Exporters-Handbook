# 📊 Prometheus Exporters Handbook

> A comprehensive production-ready guide for deploying and configuring Prometheus exporters for infrastructure monitoring.

---

## 📖 Overview

| Topic | Description |
|-------|-------------|
| **Monitoring** | Systematic observation and recording of system metrics to ensure reliability, performance, and availability |
| **Metrics** | Numerical measurements collected over time representing system state and performance |

### Use Cases

- Performance tracking and optimization
- Incident detection and alerting
- Capacity planning and resource management
- SLA compliance verification
- Root cause analysis

---

## 1. PostgreSQL Exporter

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-v18-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Exporter](https://img.shields.io/badge/Exporter-v0.18.1-orange?logo=prometheus)](https://github.com/prometheus-community/postgres_exporter)

| Property | Value |
|----------|-------|
| **Default Port** | `9187` |
| **Purpose** | Collects PostgreSQL metrics: connections, query performance, replication, table stats |

### Installation

```bash
# Download
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.18.1/postgres_exporter-0.18.1.linux-amd64.tar.gz
sudo tar -xvf postgres_exporter-0.18.1.linux-amd64.tar.gz

# Create user
sudo useradd -rs /sbin/nologin pg_exporter

# Install binary
cd postgres_exporter-0.18.1.linux-amd64
sudo mv postgres_exporter /usr/local/bin
sudo chown pg_exporter. /usr/local/bin/postgres_exporter
sudo chmod 755 /usr/local/bin/postgres_exporter

# Create config directory
sudo mkdir -p /etc/postgres_exporter
sudo vim /etc/postgres_exporter/postgres_exporter.yml

# Create systemd service
sudo vim /usr/lib/systemd/system/postgre_exporter.service
# Debian: /lib/systemd/system/postgre_exporter.service

# Firewall
sudo firewall-cmd --add-port=9187/tcp --permanent
sudo firewall-cmd --reload

# Enable service
sudo systemctl daemon-reload
sudo systemctl enable --now postgre_exporter.service
```

### Verification

```bash
sudo systemctl status postgre_exporter.service
sudo ss -tunpla | grep 9187
curl http://localhost:9187/metrics
```

### Resources

| Type | Link |
|------|------|
| **Metrics Endpoint** | `http://localhost:9187/metrics` |
| **Grafana Dashboard** | [Dashboard #9628](https://grafana.com/grafana/dashboards/9628-postgresql-database/) |
| **Repository** | [prometheus-community/postgres_exporter](https://github.com/prometheus-community/postgres_exporter) |

---

## 2. Windows Exporter

[![Windows](https://img.shields.io/badge/Windows-10%2C11-blue?logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Exporter](https://img.shields.io/badge/Exporter-v0.31.3-orange?logo=prometheus)](https://github.com/prometheus-community/windows_exporter)

| Property | Value |
|----------|-------|
| **Default Port** | `9182` |
| **Purpose** | Collects Windows system metrics: CPU, memory, disk, network, services |

### Resources

| Type | Link |
|------|------|
| **Metrics Endpoint** | `http://localhost:9182/metrics` |
| **Repository** | [prometheus-community/windows_exporter](https://github.com/prometheus-community/windows_exporter) |

---

## 3. Kafka Exporter

[![Kafka](https://img.shields.io/badge/Kafka-v2.9-blue?logo=apachekafka&logoColor=white)](https://kafka.apache.org/)
[![Exporter](https://img.shields.io/badge/Exporter-v1.9.0-orange?logo=prometheus)](https://github.com/danielqsj/kafka_exporter)

| Property | Value |
|----------|-------|
| **Default Port** | `9308` |
| **Purpose** | Collects Kafka metrics: topics, partitions, consumer groups, lag |

### Installation

```bash
# Download
wget https://github.com/danielqsj/kafka_exporter/releases/download/v1.9.0/kafka_exporter-1.9.0.linux-amd64.tar.gz
sudo tar -xvf kafka_exporter-1.9.0.linux-amd64.tar.gz

# Create user
sudo useradd -rs /sbin/nologin kafka_exporter

# Install binary
cd kafka_exporter-1.9.0.linux-amd64
sudo mv kafka_exporter /usr/local/bin/
sudo chown kafka_exporter. /usr/local/bin/kafka_exporter
sudo chmod 755 /usr/local/bin/kafka_exporter

# Create systemd service
sudo vim /usr/lib/systemd/system/kafka_exporter.service
# Debian: /lib/systemd/system/kafka_exporter.service

# Firewall
sudo firewall-cmd --add-port=9308/tcp --permanent
sudo firewall-cmd --reload

# Enable service
sudo systemctl daemon-reload
sudo systemctl enable --now kafka_exporter.service
```

### Verification

```bash
sudo systemctl status kafka_exporter.service
sudo ss -tunpla | grep 9308
curl http://localhost:9308/metrics
```

### Resources

| Type | Link |
|------|------|
| **Metrics Endpoint** | `http://localhost:9308/metrics` |
| **Grafana Dashboard** | [Dashboard #7589](https://grafana.com/grafana/dashboards/7589-kafka-exporter-overview/) |
| **Repository** | [danielqsj/kafka_exporter](https://github.com/danielqsj/kafka_exporter) |

### 💡 Notes

> - Kafka Exporter typically runs using flags in the unit file (no config file needed)
> - Currently does not support KRaft mode (requires ZooKeeper)

---

## 📁 File Paths Reference

| Exporter | Config File | Path (RHEL/CentOS) | Path (Debian/Ubuntu) |
|----------|-------------|-------------------|---------------------|
| PostgreSQL | `postgres_exporter.yml` | `/etc/postgres_exporter/` | `/etc/postgres_exporter/` |
| PostgreSQL | `postgre_exporter.service` | `/usr/lib/systemd/system/` | `/lib/systemd/system/` |
| Windows | `windows_exporter.yml` | N/A | N/A |
| Kafka | `kafka_exporter.service` | `/usr/lib/systemd/system/` | `/lib/systemd/system/` |

---

<div align="center">
  <sub>Created by Elyasdj</sub>
</div>
