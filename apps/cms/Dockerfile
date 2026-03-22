FROM node:22-bookworm-slim

WORKDIR /app

ENV STRAPI_TELEMETRY_DISABLED=true
ENV XDG_CONFIG_HOME=/tmp/xdg

COPY package*.json ./
RUN npm install

COPY . .
RUN mkdir -p /app/public/uploads

RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]
