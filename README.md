# Docker Monitoring Stack

Monitoring Stack ที่สมบูรณ์สำหรับติดตาม Docker containers โดยใช้ Prometheus, Node Exporter, cAdvisor และ Grafana

## สิ่งที่รวมอยู่ใน Stack

- **Prometheus**: สำหรับเก็บและ query metrics ต่างๆ
- **Node Exporter**: สำหรับเก็บ system metrics ของ host
- **cAdvisor**: สำหรับเก็บ container metrics
- **Grafana**: สำหรับแสดง dashboard และ visualization

## การติดตั้งและใช้งาน

### 1. Clone หรือ Download โปรเจค
```bash
git clone <repository-url>
cd moniroting-stack
```

### 2. รัน Monitoring Stack
```bash
docker compose up -d
```

### 3. เข้าถึง Services

- **Grafana Dashboard**: http://localhost:3000
  - Username: `admin`
  - Password: `admin123`

- **Prometheus**: http://localhost:9090

- **Node Exporter**: http://localhost:9100/metrics

- **cAdvisor**: http://localhost:8080
- **Alert Manager**: http://localhost:9093

### 4. ดู Dashboard

หลังจาก login เข้า Grafana แล้ว คุณจะเห็น dashboard ชื่อ "🐳 Docker Container Monitoring & Alerts" ที่รวมทุกอย่างไว้ด้วยกัน:

**📊 Overview Metrics:**
- 🚨 Active Alerts Count
- 🐳 Total Running Containers
- ⛔ Stopped Containers Count
- 🔄 Max Restarts (15m)

**📈 Container Performance:**
- 📊 Container CPU Usage (%)
- 💾 Container Memory Usage (MB)
- 📥 Container Network Receive
- 📤 Container Network Transmit

**🖥️ System Resources:**
- 🖥️ System CPU Usage (Gauge)
- 💾 System Memory Usage (Gauge)
- 💿 Disk Free
- 💿 Disk Used (Gauge)
- 🔥 Max Container CPU

**🚨 Alert Monitoring:**
- 🚨 Containers with High CPU (>80%)
- 🚨 Containers with High Memory (>80%)
- 🚨 Active Alerts Table (with color-coded severity)
- 📋 Container Status Table

## Dashboard Features

### Container Metrics
- **CPU Usage**: แสดง CPU usage ของแต่ละ container ในรูปแบบ percentage
- **Memory Usage**: แสดง memory usage ของแต่ละ container ใน MB
- **Network I/O**: แสดง network receive และ transmit ของแต่ละ container
- **Container Count**: แสดงจำนวน containers ที่กำลังทำงานอยู่

### System Metrics
- **System CPU**: CPU usage ของ host system
- **System Memory**: Memory usage ของ host system
- **Disk Space**: Available disk space

### Real-time Monitoring
- Dashboard refresh ทุก 5 วินาที
- Auto-discovery ของ containers ใหม่ (ไม่รวม monitoring stack)
- Historical data tracking

### Alert Rules
- **High Container CPU Usage**: Alert เมื่อ CPU เกิน 80% เป็นเวลา 2 นาที
- **High Container Memory Usage**: Alert เมื่อ Memory เกิน 80% เป็นเวลา 2 นาที
- **Container Not Running**: Alert เมื่อ Container หยุดทำงาน
- **High System CPU/Memory**: Alert เมื่อ System resources เกิน 90%
- **Low Disk Space**: Alert เมื่อ Disk space เหลือน้อยกว่า 10%
- **Frequent Restarts**: Alert เมื่อ Container restart เกิน 3 ครั้งใน 15 นาที

## การปรับแต่ง

### เปลี่ยน Prometheus Config
แก้ไขไฟล์ `prometheus/prometheus.yml` เพื่อเพิ่ม targets หรือปรับ scrape interval

### เพิ่ม Dashboard ใหม่
เพิ่มไฟล์ JSON ในโฟลเดอร์ `grafana/dashboards/` และ Grafana จะ auto-load

### เปลี่ยน Grafana Credentials
แก้ไข environment variables ใน `docker-compose.yml`:
```yaml
environment:
  - GF_SECURITY_ADMIN_USER=your_username
  - GF_SECURITY_ADMIN_PASSWORD=your_password
```

## การ Troubleshoot

### ตรวจสอบ Metrics
```bash
# ตรวจสอบ metrics ที่มีอยู่
./check-metrics.sh

# ตรวจสอบ Node Exporter metrics
curl http://localhost:9100/metrics | grep filesystem

# ตรวจสอบ Prometheus targets
curl http://localhost:9090/api/v1/targets
```

### ตรวจสอบ Logs
```bash
# ดู logs ของทุก service
docker compose logs

# ดู logs ของ service เฉพาะ
docker compose logs prometheus
docker compose logs grafana
```

### ปัญหาที่พบบ่อย

**Disk metrics แสดง "No data":**
- ตรวจสอบ mountpoint ที่ถูกต้อง: `./check-metrics.sh`
- ในระบบบางตัว mountpoint อาจเป็น `/var/lib` แทน `/`
- แก้ไขโดยเปลี่ยน mountpoint ใน dashboard หรือ alert rules

### ตรวจสอบ Service Status
```bash
docker compose ps
```

### Restart Services
```bash
# Restart ทั้งหมด
docker compose restart

# Restart เฉพาะ service
docker compose restart prometheus
```

## การ Cleanup

### หยุด Services
```bash
docker compose down
```

### ลบ Data Volumes
```bash
docker compose down -v
```

### ลบ Images
```bash
docker compose down --rmi all
```

## Ports ที่ใช้

- **3000**: Grafana
- **9090**: Prometheus
- **9093**: Alert Manager
- **9100**: Node Exporter
- **8080**: cAdvisor

## Requirements

- Docker (with Docker Compose plugin)
- อย่างน้อย 2GB RAM
- อย่างน้อย 10GB disk space

## Resource Limits

Monitoring Stack จะใช้ resources ดังนี้:
- **Prometheus**: CPU 0.5 cores, Memory 512MB
- **Grafana**: CPU 0.5 cores, Memory 512MB  
- **cAdvisor**: CPU 0.3 cores, Memory 256MB
- **Alert Manager**: CPU 0.2 cores, Memory 128MB
- **Node Exporter**: CPU 0.1 cores, Memory 64MB

## Security Notes

- เปลี่ยน default password ของ Grafana
- จำกัด access ผ่าน firewall ถ้า deploy ใน production
- ใช้ HTTPS สำหรับ production deployment 