# 1) Build stage
FROM node:18-alpine AS builder
WORKDIR /app

# Copy manifests and install deps
COPY package.json vite.config.js ./
RUN npm install

# Copy the HTML entry, public assets and source
COPY index.html ./
COPY public    ./public
COPY src       ./src

# Build the production bundle
RUN npm run build

# 2) Serve stage
FROM nginx:alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy in your nginx.conf
COPY nginx.conf /etc/nginx/conf.d/

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
