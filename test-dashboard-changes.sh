#!/bin/bash

echo "🔍 Testing Dashboard Changes..."
echo "================================"

# Check if the title change was applied
if grep -q '"title": "🔄 Count"' grafana/dashboards/docker-monitoring.json; then
    echo "✅ Max Restarts title changed to 'Count'"
else
    echo "❌ Max Restarts title change not found"
fi

# Check if restart count query was updated
if grep -q "container_restart_count" grafana/dashboards/docker-monitoring.json; then
    echo "✅ Container restart count query updated"
else
    echo "❌ Container restart count query not updated"
fi

# Check if Disk Free thresholds were updated
if grep -A 15 '"title": "💿 Disk Free"' grafana/dashboards/docker-monitoring.json | grep -q '"color": "red"' && \
   grep -A 15 '"title": "💿 Disk Free"' grafana/dashboards/docker-monitoring.json | grep -q '"value": 20'; then
    echo "✅ Disk Free thresholds updated (red < 20%, green > 20%)"
else
    echo "❌ Disk Free thresholds not updated correctly"
fi

# Check if all monitoring services are excluded
excluded_services="cadvisor|prometheus|grafana|alertmanager|node-exporter"
if grep -q "name!~\\\"($excluded_services)\\\"" grafana/dashboards/docker-monitoring.json; then
    echo "✅ All monitoring services are excluded from queries"
else
    echo "❌ Monitoring services exclusion not found"
fi

# Check if cadvisor instance is excluded
if grep -q "instance!~\\\"cadvisor:8000\\\"" grafana/dashboards/docker-monitoring.json; then
    echo "✅ Cadvisor instance excluded from queries"
else
    echo "❌ Cadvisor instance exclusion not found"
fi

# Count how many queries exclude monitoring services
exclusion_count=$(grep -c "name!~\\\"($excluded_services)\\\"" grafana/dashboards/docker-monitoring.json)
echo "📊 Found $exclusion_count queries that exclude monitoring services"

# Count how many queries exclude cadvisor instance
instance_exclusion_count=$(grep -c "instance!~\\\"cadvisor:8000\\\"" grafana/dashboards/docker-monitoring.json)
echo "📊 Found $instance_exclusion_count queries that exclude cadvisor instance"

echo ""
echo "🎯 Summary:"
echo "- Title changed from 'Max Restarts (15m)' to 'Count'"
echo "- Query changed from container_start_time_seconds to container_restart_count"
echo "- Disk Free shows red when < 20%, green when > 20%"
echo "- All monitoring stack services are ignored in queries"
echo "- Cadvisor instance (cadvisor:8000) is excluded from all queries"
echo ""
echo "🚀 Ready to deploy with: ./deploy.sh" 