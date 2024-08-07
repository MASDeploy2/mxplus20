# Stage 1: Build the Next.js application
FROM node:18-alpine AS builder


RUN yarn cache clean

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN yarn install

RUN mkdir -p /app/.parcel-cache && chmod -R 777 /app/.parcel-cache

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN yarn build

# Stage 2: Serve the application with NGINX
FROM nginx:alpine

# Copy the built application from the builder stage
COPY --from=builder /app/src/app/dist /usr/share/nginx/html/dist
COPY --from=builder /app /usr/share/nginx/html
# COPY --from=builder /app/public /usr/share/nginx/html

# Copy custom NGINX configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 and 443
EXPOSE 80 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
