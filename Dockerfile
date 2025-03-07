#
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci  #  npm install
COPY . .
RUN npm run build
RUN npm cache clean --force

#
FROM node:18-alpine AS runner
WORKDIR /app

#  package.json  package-lock.json ( yarn.lock)
COPY --from=builder /app/package*.json ./

#
RUN npm install --production

#
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
EXPOSE 3000
CMD ["npm", "start"]
