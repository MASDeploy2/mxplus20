FROM node:18-alpine AS base


WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package*.json ./

# run command
run npm install

COPY . .


EXPOSE 8080


CMD ["npm","start"]
