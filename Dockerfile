FROM node:18-alpine AS base


WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package*.json ./

# run command
RUN yarn install

RUN mkdir /app/.parcel-cache && chmod -R 777 /app/.parcel-cache && chmod -R 777 /app

COPY . .



EXPOSE 8080


CMD ["yarn","run","start"]
