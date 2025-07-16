#!/bin/bash

# Deploy Container Details Dashboard Script
# สคริปต์สำหรับ deploy dashboard ที่แสดงรายละเอียดของแต่ละ container

set -e

echo "🚀 Deploying Container Details Dashboard..."

# ตรวจสอบว่า Docker ทำงานอยู่หรือไม่
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running. Please start Docker first."
    exit 1
fi

# ตรวจสอบว่าไฟล์ dashboard ใหม่มีอยู่หรือไม่
if [ ! -f "grafana/dashboards/container-details.json" ]; then
    echo "❌ Error: Container details dashboard file not found!"
    exit 1
fi

echo "✅ Container details dashboard file found"

# Restart Grafana เพื่อโหลด dashboard ใหม่
echo "🔄 Restarting Grafana to load new dashboard..."
docker compose restart grafana

# รอให้ Grafana พร้อมใช้งาน
echo "⏳ Waiting for Grafana to be ready..."
sleep 15

# ตรวจสอบสถานะ services
echo "📊 Checking service status..."
docker compose ps

echo ""
echo "🎉 Container Details Dashboard deployed successfully!"
echo ""
echo "📱 Access your new dashboard:"
echo "   Grafana: http://localhost:3000"
echo "   Username: admin"
echo "   Password: admin123"
echo ""
echo "📊 New Dashboard:"
echo "   - 🐳 Container Details Dashboard (Excluding Monitor Stack)"
echo ""
echo "🔍 Dashboard Features:"
echo "   - 📊 Container CPU Usage by Name (%)"
echo "   - 💾 Container Memory Usage by Name (MB)"
echo "   - 🌐 Container Network I/O by Name (bytes/sec)"
echo "   - 💿 Container Disk I/O by Name (bytes/sec)"
echo "   - 📋 Container Details Table"
echo ""
echo "✨ All panels exclude monitoring stack containers:"
echo "   - cadvisor, prometheus, grafana, alertmanager, node-exporter"
echo ""
echo "📋 Useful commands:"
echo "   View logs: docker compose logs grafana"
echo "   Stop services: docker compose down"
echo "   Restart services: docker compose restart"
echo "" 