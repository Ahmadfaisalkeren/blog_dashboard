# Stage 1: Build React app
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile

# Copy the rest of the project and build it
COPY . .
RUN npm run build

# Stage 2: Serve with Caddy
FROM caddy:latest AS runner

WORKDIR /srv

# Copy built frontend files
COPY --from=builder /app/dist /srv

# Copy Caddyfile (for better routing)
COPY Caddyfile /etc/caddy/Caddyfile

# Expose HTTP & HTTPS ports
EXPOSE 80 443

# Start Caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
