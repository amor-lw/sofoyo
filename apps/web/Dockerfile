FROM node:22-bookworm-slim

WORKDIR /app

ENV ASTRO_TELEMETRY_DISABLED=1

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

EXPOSE 4321

CMD ["node", "./dist/server/entry.mjs"]
