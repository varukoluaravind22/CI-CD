#!/bin/bash

set -e

echo "📦 Updating system..."
sudo apt update -y

echo "📦 Installing dependencies..."
sudo apt install -y wget tar curl

# -----------------------------
# 🚀 Install Prometheus
# -----------------------------
echo "⬇️ Installing Prometheus..."

cd /tmp
wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-*.linux-amd64.tar.gz
tar -xvf prometheus-*.linux-amd64.tar.gz

PROM_DIR=$(ls | grep prometheus-)

sudo mv $PROM_DIR /opt/prometheus

sudo useradd --no-create-home --shell /bin/false prometheus || true

sudo mkdir -p /etc/prometheus
sudo mkdir -p /var/lib/prometheus

sudo cp /opt/prometheus/prometheus /usr/local/bin/
sudo cp /opt/prometheus/promtool /usr/local/bin/

sudo cp -r /opt/prometheus/consoles /etc/prometheus
sudo cp -r /opt/prometheus/console_libraries /etc/prometheus

# Prometheus config
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
EOF

# Prometheus service
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus

[Install]
WantedBy=multi-user.target
EOF

sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus

echo "✅ Prometheus installed and running on port 9090"

# -----------------------------
# 📊 Install Grafana
# -----------------------------
echo "⬇️ Installing Grafana..."

sudo apt-get install -y software-properties-common

sudo mkdir -p /etc/apt/keyrings
wget -q -O - https://packages.grafana.com/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/grafana.gpg

echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt update -y
sudo apt install -y grafana

sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "✅ Grafana installed and running on port 3000"

# -----------------------------
# 🔥 Final Info
# -----------------------------
echo "--------------------------------------"
echo "🎯 Access URLs:"
echo "Prometheus: http://<your-ip>:9090"
echo "Grafana:    http://<your-ip>:3000"
echo ""
echo "Grafana login:"
echo "Username: admin"
echo "Password: admin"
echo "--------------------------------------"