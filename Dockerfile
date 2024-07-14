FROM node:18-alpine AS base

# Elevate privileges to run npm
USER root

WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package*.json ./

# run command
RUN yarn install

COPY . .

USER root
RUN chown -R 1001:0 /app

# Restore default user privileges
USER 1001


# Container exposes port 3000
EXPOSE 3000

# Listen on port 3000
ENV PORT 3000

EXPOSE 8080


CMD ["yarn","run","start"]
