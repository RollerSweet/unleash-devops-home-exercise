# build app and prepare prod deps
FROM node:20-alpine AS build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm ci
COPY tsconfig.json index.ts ./
RUN npm run build && npm prune --omit=dev

# run app
FROM node:20-alpine
WORKDIR /usr/src/app
ENV NODE_ENV=production
USER node
COPY --from=build --chown=node:node /usr/src/app/node_modules ./node_modules
COPY --from=build --chown=node:node /usr/src/app/dist ./dist
CMD ["node", "dist/index.js"]
