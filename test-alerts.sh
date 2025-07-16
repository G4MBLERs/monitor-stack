#!/bin/bash

# Test Alerts Script
# สคริปต์สำหรับทดสอบ alerts โดยการสร้าง containers ที่ใช้ resources สูง

echo "🧪 Testing Container Alerts..."

# สร้าง container ที่ใช้ CPU สูง
echo "📈 Creating high CPU usage container..."
docker run -d --name test-high-cpu \
  --cpus=0.5 \
  alpine sh -c "while true; do : ; done" > /dev/null 2>&1

# สร้าง container ที่ใช้ Memory สูง
echo "📊 Creating high memory usage container..."
docker run -d --name test-high-memory \
  --memory=512m \
  alpine sh -c "while true; do dd if=/dev/zero of=/tmp/test bs=1M count=100; done" > /dev/null 2>&1

# สร้าง container ที่จะ restart บ่อย
echo "🔄 Creating frequently restarting container..."
docker run -d --name test-restart \
  --restart=always \
  alpine sh -c "sleep 10; exit 1" > /dev/null 2>&1

echo ""
echo "✅ Test containers created:"
echo "   - test-high-cpu: Container ที่ใช้ CPU สูง"
echo "   - test-high-memory: Container ที่ใช้ Memory สูง"
echo "   - test-restart: Container ที่จะ restart บ่อย"
echo ""
echo "📊 Check your Dashboard at: http://localhost:3000"
echo "   Look for '🐳 Docker Container Monitoring & Alerts' dashboard"
echo ""
echo "⏰ Wait 2-3 minutes for alerts to trigger..."
echo ""
echo "🧹 To clean up test containers:"
echo "   docker stop test-high-cpu test-high-memory test-restart"
echo "   docker rm test-high-cpu test-high-memory test-restart" 