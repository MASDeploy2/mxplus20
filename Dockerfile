FROM node:18-alpine AS base

USER root
WORKDIR /usr/app 

# Install dependencies based on the preferred package manager 

COPY package*.json ./ 

RUN yarn install

COPY --from=base /usr/app/node_modules ./node_modules 
COPY . .

RUN mkdir /usr/app/.parcel-cache && chmod -R 777 /usr/app/.parcel-cache

ENV NEXT_TELEMETRY_DISABLED 1 

RUN yarn build 

USER root

# stage: 2 — the production environment
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=base --chown=1001:1001 /usr/app/src/app ./
USER 1001
EXPOSE 80
EXPOSE 443
CMD [“nginx”, “-g”, “daemon off;”]



