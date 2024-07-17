FROM node:18-alpine AS base

WORKDIR /usr/app 

# Install dependencies based on the preferred package manager 

COPY package*.json ./ 

RUN yarn install

<<<<<<< HEAD

=======
>>>>>>> 6f31e117c5ce09d8b5f7893f731b491c6d9f3f3a
COPY --from=base /usr/app/node_modules ./node_modules 
COPY . .

RUN mkdir /usr/app/.parcel-cache && chmod -R 777 /usr/app/.parcel-cache

ENV NEXT_TELEMETRY_DISABLED 1 

RUN mkdir .next
RUN mkdir /usr/app/.parcel-cache && chmod -R 777 /usr/app/.parcel-cache

RUN yarn build 

FROM nginx:alpine
<<<<<<< HEAD

WORKDIR /usr/app

RUN apk add nodejs-current npm supervisor
RUN mkdir -p /var/log/supervisor && mkdir -p /etc/supervisor/conf.d

# Remove any existing config files
RUN rm /etc/nginx/conf.d/*

# Copy nginx config files
# *.conf files in conf.d/ dir get included in main config
COPY ./.nginx/default.conf /etc/nginx/conf.d/

# COPY package.json next.config.js .env* ./
# COPY --from=base /usr/app/public ./public
COPY --from=base /usr/app/.next ./.next
COPY --from=base /usr/app/node_modules ./node_modules


# supervisor base configuration
ADD supervisor.conf /etc/supervisor.conf

EXPOSE 3000
=======
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=base /usr/app/src/dist .
USER 1001
>>>>>>> 6f31e117c5ce09d8b5f7893f731b491c6d9f3f3a
EXPOSE 80
EXPOSE 443

# replace $PORT in nginx config (provided by executior) and start supervisord (run nextjs and nginx)
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && \
  supervisord -c /etc/supervisor.conf

