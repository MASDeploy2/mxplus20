FROM node:18-alpine AS base

FROM base as deps

USER 0 

WORKDIR /app 


# Install dependencies based on the preferred package manager 

COPY package*.json ./ 
COPY . . 

RUN yarn install

# Rebuild the source code only when needed FROM node:18-Alpine AS builder
FROM base AS builder
USER 0 
WORKDIR /app 
RUN mkdir /app/.parcel-cache && chmod -R 777 /app/.parcel-cache && chmod -R 777 /app
COPY --from=deps /app/node_modules ./node_modules 
COPY . . 
ENV NEXT_TELEMETRY_DISABLED 1 

RUN yarn build 

FROM base AS runner

USER 0 WORKDIR /app 

ENV NODE_ENV production 

COPY --from=builder /app/public ./public 
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size 
# https://nextjs.org/docs/advanced-features/output-file-tracing 

COPY --from=builder --chown=1001:1001 /app/.next/standalone ./ 
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static


USER 1001


# nginx/Dockerfile

FROM nginx:1.23.3-alpine

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 443
EXPOSE 3000

ENV PORT 3000


CMD [“yarn”, “run”, “start”]
