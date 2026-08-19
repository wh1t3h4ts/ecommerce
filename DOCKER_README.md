# 🐳 Docker Testing Guide for OWAT Kenya Backend

## Prerequisites

- Docker Desktop installed and running
- Docker Compose installed (comes with Docker Desktop)

## 🚀 Quick Start

### 1. Start All Services (Backend + MongoDB + Mongo Express)

```bash
cd "c:\Users\USER\Desktop\ecommerce-OneShop"
docker-compose up -d
```

This will start:
- ✅ **MongoDB** on port `27017`
- ✅ **Backend API** on port `5000`
- ✅ **Mongo Express (DB GUI)** on port `8081`

### 2. View Logs

```bash
# View all logs
docker-compose logs -f

# View backend logs only
docker-compose logs -f backend

# View MongoDB logs only
docker-compose logs -f mongodb
```

### 3. Check Service Health

```bash
# Check if backend is running
curl http://localhost:5000/health

# Or open in browser
# http://localhost:5000/health
```

### 4. Access MongoDB GUI

Open in browser: http://localhost:8081
- Username: `admin`
- Password: `admin`

## 🧪 Testing the API

### Test Endpoints

```bash
# 1. Health Check
curl http://localhost:5000/health

# 2. Get Products (will be empty initially)
curl http://localhost:5000/api/v1/products

# 3. Register a User
curl -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Test User\",\"email\":\"test@owatkenya.com\",\"password\":\"TestPass123!\"}"

# 4. Login
curl -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"test@owatkenya.com\",\"password\":\"TestPass123!\"}"
```

## 🔧 Useful Docker Commands

### Stop All Services
```bash
docker-compose down
```

### Stop and Remove All Data (Fresh Start)
```bash
docker-compose down -v
```

### Rebuild Backend
```bash
docker-compose up -d --build backend
```

### View Running Containers
```bash
docker-compose ps
```

### Access Backend Container Shell
```bash
docker exec -it owat-backend sh
```

### Access MongoDB Shell
```bash
docker exec -it owat-mongodb mongosh -u admin -p owatkenya2024 --authenticationDatabase admin
```

## 📊 Service URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| Backend API | http://localhost:5000 | N/A |
| Health Check | http://localhost:5000/health | N/A |
| MongoDB | mongodb://localhost:27017 | admin / owatkenya2024 |
| Mongo Express | http://localhost:8081 | admin / admin |

## 🐛 Troubleshooting

### Backend won't start
```bash
# Check logs
docker-compose logs backend

# Rebuild
docker-compose up -d --build backend
```

### MongoDB connection error
```bash
# Check MongoDB status
docker-compose ps mongodb

# Restart MongoDB
docker-compose restart mongodb
```

### Port already in use
```bash
# Stop the service using the port
# For Windows:
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Then restart Docker services
docker-compose up -d
```

### Clean everything and start fresh
```bash
docker-compose down -v
docker system prune -a
docker-compose up -d
```

## 🔄 Development Workflow

### Watch for changes (Hot Reload)
The backend is configured with volume mounts, so code changes will automatically reload:

1. Edit code in `backend/src/`
2. Save the file
3. Backend will automatically restart with changes

### Add Sample Data

Access Mongo Express (http://localhost:8081) and manually add:
- Products
- Categories
- Users

Or use the API endpoints to create data.

## 📝 Environment Variables

The docker-compose.yml includes all necessary environment variables:
- MongoDB credentials
- JWT secrets
- API configuration

To customize, edit `docker-compose.yml` under `backend.environment`

## 🧹 Cleanup

### Remove all containers and images
```bash
docker-compose down --rmi all -v
```

### Remove only volumes (data)
```bash
docker-compose down -v
```

## ✅ Verify Everything is Working

Run this command to check all services:
```bash
docker-compose ps
```

Expected output:
```
NAME                IMAGE               STATUS
owat-backend        backend             Up (healthy)
owat-mongodb        mongo:7.0           Up (healthy)
owat-mongo-express  mongo-express       Up
```

## 🚀 Next Steps

1. Test all API endpoints using Postman or curl
2. Connect frontend to http://localhost:5000/api/v1
3. Add sample products via Mongo Express
4. Test user registration and login
5. Test cart and order functionality

---

**Need Help?** Check the logs: `docker-compose logs -f`
