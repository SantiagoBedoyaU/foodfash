# FoodFlash - Crisis Simulation Project
## Instalación Rápida
### Opción 1: Con Docker (Recomendado)
```bash
# Levantar base de datos y cache
docker-compose up -d
# Instalar dependencias y ejecutar
cd backend && npm install && npm run dev &
cd frontend && npm start
```
### Opción 2: Manual
```bash
# 1. Instalar PostgreSQL y Redis localmente
# 2. Crear base de datos
createdb foodflash_dev
# 3. Setup backend
cd backend
npm install
npm run setup-db
npm run dev
# 4. Setup frontend (en otra terminal)
cd frontend
npm start
```
## Para Crear Crisis
```bash
# Script de carga masiva (incluir en terminal separada)
for i in {1..1000}; do
 curl -X POST http://localhost:3001/api/orders \
 -H "Content-Type: application/json" \
 -d
'{"userId":1,"restaurantId":1,"items":[{"id":1,"name":"Pizza","quantity
":1,"price":15.99}],"total":15.99,"paymentInfo":{"paymentMethodId":"tes
t"}}' &
done
```
## URLs del Sistema
- **Frontend**: http://localhost:3000
- **Backend Health**: http://localhost:3001/health
- **API Health**: http://localhost:3001/api/health