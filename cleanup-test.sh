#!/bin/bash

# Cleanup Test Containers Script
# สคริปต์สำหรับลบ test containers

echo "🧹 Cleaning up test containers..."

# หยุดและลบ test containers
docker stop test-high-cpu test-high-memory test-restart 2>/dev/null || true
docker rm test-high-cpu test-high-memory test-restart 2>/dev/null || true

echo "✅ Test containers cleaned up successfully!"
echo ""
echo "📊 Alerts should resolve automatically in a few minutes" 