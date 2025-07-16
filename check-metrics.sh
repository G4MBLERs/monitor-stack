#!/bin/bash

# Check Metrics Script
# สคริปต์สำหรับตรวจสอบ metrics ที่มีอยู่

echo "🔍 Checking available metrics..."

# ตรวจสอบ Node Exporter
echo ""
echo "📊 Node Exporter Metrics:"
echo "=========================="
curl -s http://localhost:9100/metrics | grep -E "node_filesystem_(avail|size)_bytes" | grep -v "#" | head -5

echo ""
echo "📊 Available mountpoints:"
echo "=========================="
curl -s http://localhost:9100/metrics | grep -E "node_filesystem_(avail|size)_bytes" | grep -v "#" | awk -F'[{}]' '{print $2}' | sort | uniq | head -10

echo ""
echo "📊 Container Metrics:"
echo "===================="
curl -s http://localhost:8080/metrics | grep -E "container_(cpu|memory)" | grep -v "#" | head -5

echo ""
echo "📊 Prometheus Targets:"
echo "====================="
curl -s http://localhost:9090/api/v1/targets | jq '.data.activeTargets[] | {job: .labels.job, health: .health, lastError: .lastError}' 2>/dev/null || echo "jq not installed or Prometheus not running"

echo ""
echo "✅ Metrics check completed!" 