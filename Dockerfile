FROM node:24-bullseye

# Create app directory
WORKDIR /app

# Copy package files for frontend/backend to leverage docker layer caching
COPY frontend/package*.json ./frontend/
COPY backend/package*.json ./backend/

# Install dependencies for frontend and backend
RUN cd frontend && npm ci --omit=dev
RUN cd ../backend && npm ci --omit=dev

# Copy the rest of the source
COPY . .

# Build frontend
RUN npm --prefix frontend run build

# Expose port (Cloud Run uses 8080 by default)
ENV PORT=8080
EXPOSE 8080

# Start the backend server
CMD ["node", "backend/src/index.js"]
