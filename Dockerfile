# Install the application dependencies in a full UBI Node docker image
FROM node:18-alpine AS base

# Elevate privileges to run npm
USER root

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./


# Install app dependencies
RUN yarn install

# Copy the dependencies into a minimal Node.js image
FROM node:18-slim AS final
WORKDIR /app

# copy the app dependencies
COPY --from=base /app/node_modules ./node_modules
COPY . .

# Build the pacckages in minimal image
RUN yarn build

# Elevate privileges to change owner of source files
USER root
RUN chown -R 1001:0 /app/src

# Restore default user privileges
USER 1001

# Run application in 'development' mode
ENV NODE_ENV development

# Listen on port 3000
ENV PORT 3000

# Container exposes port 3000
EXPOSE 3000

# Start node process
CMD ["yarn", "start"]