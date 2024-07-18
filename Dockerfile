# Stage 1: Build the Next.js application
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN yarn install --network-timeout 600000

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN yarn build

