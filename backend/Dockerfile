# Imagen base de Node.js
FROM node:20-alpine

# Directorio de trabajo
WORKDIR /app

# Copiar dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto del backend
COPY . .

# Exponer el puerto del backend (por defecto 3001)
EXPOSE 3001

# Comando por defecto
CMD ["npm", "run", "dev"]