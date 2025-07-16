#!/bin/bash

# Test Container Dashboard with Sample Containers
# สคริปต์สำหรับทดสอบ dashboard ด้วย containers ตัวอย่าง

echo "🧪 Testing Container Dashboard with Sample Containers..."
echo "======================================================="

# สร้าง containers ตัวอย่างที่มีชื่อที่แตกต่างกัน
echo "🐳 Creating sample containers..."

# Container ที่ใช้ CPU สูง
echo "📈 Creating high CPU usage container..."
docker run -d --name test-app-1 \
  --cpus=0.3 \
  alpine sh -c "while true; do : ; done" > /dev/null 2>&1

# Container ที่ใช้ Memory สูง
echo "📊 Creating high memory usage container..."
docker run -d --name test-app-2 \
  --memory=256m \
  alpine sh -c "while true; do dd if=/dev/zero of=/tmp/test bs=1M count=50; done" > /dev/null 2>&1

# Container ที่ใช้ Network สูง
echo "🌐 Creating high network usage container..."
docker run -d --name test-app-3 \
  alpine sh -c "while true; do wget -q -O /dev/null http://httpbin.org/bytes/1000; done" > /dev/null 2>&1

# Container ที่ใช้ Disk I/O สูง
echo "💿 Creating high disk I/O container..."
docker run -d --name test-app-4 \
  alpine sh -c "while true; do dd if=/dev/zero of=/tmp/io_test bs=1M count=10; rm /tmp/io_test; done" > /dev/null 2>&1

# Container ปกติ
echo "📦 Creating normal container..."
docker run -d --name test-app-5 \
  nginx:alpine > /dev/null 2>&1

echo ""
echo "✅ Sample containers created:"
echo "   - test-app-1: High CPU usage"
echo "   - test-app-2: High Memory usage"
echo "   - test-app-3: High Network usage"
echo "   - test-app-4: High Disk I/O usage"
echo "   - test-app-5: Normal nginx container"
echo ""
echo "📊 Check your Container Details Dashboard at: http://localhost:3000"
echo "   Look for '🐳 Container Details Dashboard (Excluding Monitor Stack)'"
echo ""
echo "⏰ Wait 1-2 minutes for metrics to appear..."
echo ""
echo "🔍 You should see:"
echo "   - Container names in all panel legends"
echo "   - Different CPU/Memory/Network/Disk patterns"
echo "   - No monitoring stack containers (cadvisor, prometheus, etc.)"
echo ""
echo "🧹 To clean up test containers:"
echo "   docker stop test-app-1 test-app-2 test-app-3 test-app-4 test-app-5"
echo "   docker rm test-app-1 test-app-2 test-app-3 test-app-4 test-app-5"
echo ""
echo "📋 Or use cleanup script:"
echo "   ./cleanup-test.sh" 