FROM node:18-alpine AS base

FROM base as deps


WORKDIR /app 

# Install dependencies based on the preferred package manager 

COPY package*.json ./ 

RUN yarn install

# Rebuild the source code only when needed FROM node:18-Alpine AS builder
FROM base AS builder

WORKDIR /app 
RUN mkdir /app/.parcel-cache && chmod -R 777 /app/.parcel-cache && chmod -R 777 /app
COPY --from=deps /app/node_modules ./node_modules 

ENV NEXT_TELEMETRY_DISABLED 1 

RUN yarn build 

RUN chown -R 1001:0 /app

ENV NODE_ENV production 

COPY --from=builder /app/public ./public 

RUN mkdir .next

RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size 
# https://nextjs.org/docs/advanced-features/output-file-tracing 

COPY --from=builder --chown=1001:1001 /app/.next/standalone ./ 
COPY --from=builder --chown=1001:1001 /app/.next/static ./.next/static

USER 1001

FROM nginx:alpine

WORKDIR /app

RUN apk add nodejs-current npm supervisor
RUN mkdir mkdir -p /var/log/supervisor && mkdir -p /etc/supervisor/conf.d

# Remove any existing config files
RUN rm /etc/nginx/conf.d/*

# Copy nginx config files
# *.conf files in conf.d/ dir get included in main config
COPY ./.nginx/default.conf /etc/nginx/conf.d/

# COPY package.json next.config.js .env* ./
# COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules

# supervisor base configuration
ADD supervisor.conf /etc/supervisor.conf

# replace $PORT in nginx config (provided by executior) and start supervisord (run nextjs and nginx)
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && \
supervisord -c /etc/supervisor.conf

EXPOSE 80
EXPOSE 443
EXPOSE 3000

ENV PORT 3000


CMD [“yarn”, “run”, “start”]
