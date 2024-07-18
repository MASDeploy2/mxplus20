# Stage 1: Build the Next.js application
FROM node:19-alpine AS builder

RUN yarn set version latest
RUN yarn cache clean

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --network-timeout 600000

# Copy the rest of the application code
COPY . .

# Build the Next.js application
RUN npm run build

