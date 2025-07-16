#!/bin/bash

# Docker Monitoring Stack Deployment Script
# สคริปต์สำหรับ deploy monitoring stack

set -e

echo "🚀 Starting Docker Monitoring Stack Deployment..."

# ตรวจสอบว่า Docker ทำงานอยู่หรือไม่
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running. Please start Docker first."
    exit 1
fi

# ตรวจสอบว่า Docker Compose plugin ติดตั้งแล้วหรือไม่
if ! docker compose version &> /dev/null; then
    echo "❌ Error: Docker Compose plugin is not installed. Please install Docker Compose plugin first."
    exit 1
fi

echo "✅ Docker and Docker Compose plugin are available"

# Pull latest images
echo "📥 Pulling latest Docker images..."
docker compose pull

# Start services
echo "🔄 Starting monitoring services..."
docker compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check service status
echo "📊 Checking service status..."
docker compose ps

echo ""
echo "🎉 Monitoring Stack deployed successfully!"
echo ""
echo "📱 Access your monitoring dashboards:"
echo "   Grafana: http://localhost:3000"
echo "   Username: admin"
echo "   Password: admin123"
echo ""
echo "📊 Available Dashboard:"
echo "   - 🐳 Docker Container Monitoring & Alerts (unified dashboard)"
echo ""
echo "🔧 Other services:"
echo "   Prometheus: http://localhost:9090"
echo "   Alert Manager: http://localhost:9093"
echo "   Node Exporter: http://localhost:9100"
echo "   cAdvisor: http://localhost:8080"
echo ""
echo "📋 Useful commands:"
echo "   View logs: docker compose logs"
echo "   Stop services: docker compose down"
echo "   Restart services: docker compose restart"
echo "" 