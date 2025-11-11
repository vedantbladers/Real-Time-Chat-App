# Use Node 24 (latest LTS as of 2025)
FROM node:24-bullseye

# Set working directory
WORKDIR /app

# Backend: copy package files and install dependencies
COPY backend/package*.json ./backend/
WORKDIR /app/backend
RUN npm ci --omit=dev

# Frontend: copy package files, install deps
COPY frontend/package*.json ./frontend/
WORKDIR /app/frontend
RUN npm ci --omit=dev

# Copy full sources after deps to take advantage of layer caching
COPY backend/ ./backend/
COPY frontend/ ./frontend/

# Build frontend (output will be at /app/frontend/dist)
WORKDIR /app/frontend
RUN npm run build

# Expose port and start backend
ENV PORT=8080
EXPOSE 8080
WORKDIR /app/backend
CMD ["npm", "start"]
