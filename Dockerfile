# --- Builder stage ---------------------------------------------------------
# 1. Use a lightweight Node image
FROM node:18-alpine AS builder

# 2. Set working dir
WORKDIR /app

# 3. Copy dependency manifests
COPY package.json package-lock.json* ./

# 4. Install deps
RUN npm install

# 5. Copy the rest of the source
COPY . .

# 6. Build for production (outputs to /app/dist by default)
RUN npm run build



# --- Production stage ------------------------------------------------------
# 1. Use the official Nginx Alpine image
FROM nginx:alpine

# 2. Remove the default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# 3. Copy our production build
COPY --from=builder /app/dist /usr/share/nginx/html

# 4. Expose port 80
EXPOSE 80

# 5. Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
