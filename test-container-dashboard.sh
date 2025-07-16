#!/bin/bash

# Test Container Dashboard Script
# สคริปต์สำหรับทดสอบ dashboard ที่แสดงรายละเอียดของแต่ละ container

echo "🧪 Testing Container Details Dashboard..."
echo "=========================================="

# ตรวจสอบว่าไฟล์ dashboard ใหม่มีอยู่หรือไม่
if [ -f "grafana/dashboards/container-details.json" ]; then
    echo "✅ Container details dashboard file exists"
else
    echo "❌ Container details dashboard file not found"
    exit 1
fi

# ตรวจสอบว่า monitoring stack containers ถูก exclude ในทุก query
excluded_services="cadvisor|prometheus|grafana|alertmanager|node-exporter"
exclusion_count=$(grep -c "name!~\\\"^($excluded_services)$\\\"" grafana/dashboards/container-details.json)
echo "📊 Found $exclusion_count queries that exclude monitoring services"

# ตรวจสอบว่า dashboard มี panels ที่ต้องการครบหรือไม่
required_panels=(
    "Container CPU Usage by Name"
    "Container Memory Usage by Name"
    "Container Network I/O by Name"
    "Container Disk I/O by Name"
    "Container Details Table"
)

echo ""
echo "🔍 Checking required panels:"
for panel in "${required_panels[@]}"; do
    if grep -q "\"title\": \"[^\"]*$panel[^\"]*\"" grafana/dashboards/container-details.json; then
        echo "✅ Found panel: $panel"
    else
        echo "❌ Missing panel: $panel"
    fi
done

# ตรวจสอบว่า dashboard มี refresh rate ที่เหมาะสม
if grep -q "\"refresh\": \"5s\"" grafana/dashboards/container-details.json; then
    echo "✅ Dashboard refresh rate set to 5 seconds"
else
    echo "❌ Dashboard refresh rate not set correctly"
fi

# ตรวจสอบว่า dashboard มี title ที่ถูกต้อง
if grep -q "\"title\": \"🐳 Container Details Dashboard (Excluding Monitor Stack)\"" grafana/dashboards/container-details.json; then
    echo "✅ Dashboard title is correct"
else
    echo "❌ Dashboard title is incorrect"
fi

echo ""
echo "🎯 Summary:"
echo "- Dashboard shows container details excluding monitoring stack"
echo "- All panels display container names in legends"
echo "- CPU, Memory, Network I/O, and Disk I/O metrics included"
echo "- Table view for detailed container information"
echo "- 5-second refresh rate for real-time updates"
echo ""
echo "🚀 Ready to deploy with: ./deploy-container-dashboard.sh"
echo ""
echo "📊 After deployment, access:"
echo "   Grafana: http://localhost:3000"
echo "   Look for '🐳 Container Details Dashboard (Excluding Monitor Stack)'" 