FROM node:18-alpine AS base

ARG http_port=3000
ARG https_port=9443

# Elevate privileges to run npm
USER root

WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package*.json ./

# run command
RUN yarn install
RUN mkdir /app/.parcel-cache && chmod -R 777 /app/.parcel-cache && chmod -R 777 /app
COPY . .

USER root
RUN chown -R 1001:0 /app

# Restore default user privileges
USER 1001


# Container exposes port 
EXPOSE 3000
EXPOSE 9443
EXPOSE 8080


CMD ["yarn","run","start"]
