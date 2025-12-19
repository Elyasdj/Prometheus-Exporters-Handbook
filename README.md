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

### 1. PostgreSQL Exporter

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-v18-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![PostgreSQL Exporter](https://img.shields.io/badge/PostgreSQL_Exporter-v0.18.1-orange?logo=prometheus)](https://github.com/prometheus-community/postgres_exporter)

**Default Port**: `9187`

#### What is PostgreSQL Exporter?
A Prometheus exporter that collects and exposes PostgreSQL database metrics including connection stats, query performance, replication status, and table statistics.

#### Binary Installation Steps (RH/DEB)

```bash
# Download PostgreSQL Exporter
wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.18.1/postgres_exporter-0.18.1.linux-amd64.tar.gz
sudo tar -xvf postgres_exporter-0.18.1.linux-amd64.tar.gz

# Create user
sudo useradd -rs /sbin/nologin pg_exporter

# Install binary
cd postgres_exporter-0.18.1.linux-amd64
sudo mv postgres_exporter /usr/local/bin
sudo chown pg_exporter. /usr/local/bin/postgres_exporter
sudo chmod 755 /usr/local/bin/postgres_exporter

# Create config path & config 
sudo mkdir -p /etc/postgres_exporter
sudo vim /etc/postgres_exporter/postgres_exporter.yml

# Create systemd service
sudo vim /usr/lib/systemd/system/postgre_exporter.service
# For Debian Distro Use This Path /lib/systemd/system/postgre_exporter.service

# Configure firewall
sudo firewall-cmd --add-port=9187/tcp --permanent
sudo firewall-cmd --reload

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable --now postgre_exporter.service
```

#### Verification
```bash
sudo systemctl status postgre_exporter.service
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

### 2. Windows Exporter

[![Windows](https://img.shields.io/badge/Windows-10%2C11-blue?logo=windows&logoColor=white)](https://www.microsoft.com/windows)
[![Windows Exporter](https://img.shields.io/badge/Windows_Exporter-v0.31.3-orange?logo=prometheus)](https://github.com/prometheus-community/windows_exporter)

**Default Port**: `9182`

.
.
.
.
.

#### Official Repository
📦 [Prometheus/Windows_Exporter](https://github.com/prometheus-community/windows_exporter)

---

### 3. Kafka Exporter

[![Kafka](https://img.shields.io/badge/Kafka-v2.9-blue?logo=apachekafka&logoColor=white)](https://kafka.apache.org/)
[![Kafka Exporter](https://img.shields.io/badge/Kafka_Exporter-v1.9.0-orange?logo=prometheus)](https://github.com/danielqsj/kafka_exporter)

**Default Port**: `9308`

#### What is Kafka Exporter?

#### Binary Installation Steps (RH/DEB)

```bash
# Download Kafka Exporter
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
# For Debian Distro Use This Path /lib/systemd/system/kafka_exporter.service

# Configure firewall
sudo firewall-cmd --add-port=9308/tcp --permanent
sudo firewall-cmd --reload

# Enable and start service
sudo systemctl daemon-reload
sudo systemctl enable --now kafka_exporter.service
```

#### Verification
```bash
sudo systemctl status kafka_exporter.service
sudo ss -tunpla | grep 9308
```

#### Access
`http://localhost:9308/metrics` or `http://your-ip:9308/metrics`

#### Test Metrics
```bash
curl http://localhost:9308/metrics
```

## 💡 Pro Tips

- Kafka Exporter usually does not require a configuration file and is typically run using flags in the unit file.
- As of now, danielqsj/kafka_exporter does not support the KRaft mode yet and still requires ZooKeeper.

#### Grafana Dashboard
📦 [Grafana/Dashboards](https://grafana.com/grafana/dashboards/7589-kafka-exporter-overview/)

#### Official Repository
📦 [Prometheus/Kafka_Exporter](https://github.com/danielqsj/kafka_exporter)

---

<div align="center">
  <sub>Created with by Elyasdj</sub>
</div>
