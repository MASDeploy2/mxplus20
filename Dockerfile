FROM node:18-Alpine AS deps 

USER 0 

WORKDIR /app 


# Install dependencies based on the preferred package manager 

COPY package*.json ./ 

RUN yarn install --frozen-lockfile --production --network-timeout 300000 

# Rebuild the source code only when needed FROM node:18-Alpine AS builder

USER 0 

WORKDIR /app 
COPY --from=deps /app/node_modules ./node_modules 
COPY . . 
ENV NEXT_TELEMETRY_DISABLED 1 

RUN yarn build FROM node:18-Alpine AS runner

USER 0 WORKDIR /app 

ENV NODE_ENV production 
COPY --from=builder /app/public ./public 

# Automatically leverage output traces to reduce image size 
# https://nextjs.org/docs/advanced-features/output-file-tracing 
COPY --from=builder --chown=1001:1001 /app/.next/standalone ./ 
COPY --from=builder --chown=1001:1001 /app/.next/static ./.next/static 

USER 1001

EXPOSE 8080

EXPOSE 443

ENV PORT 8080 

CMD [“yarn”, “run”, “start”]
