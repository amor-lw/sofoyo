FROM node:22-bookworm-slim

WORKDIR /app

ARG BUILD_NODE_OPTIONS=--max-old-space-size=2048
ARG NPM_REGISTRY=https://registry.npmmirror.com
ARG SHARP_BINARY_HOST=https://registry.npmmirror.com/-/binary/sharp
ARG SHARP_LIBVIPS_BINARY_HOST=https://registry.npmmirror.com/-/binary/sharp-libvips

ENV STRAPI_TELEMETRY_DISABLED=true
ENV XDG_CONFIG_HOME=/tmp/xdg

COPY package*.json ./
RUN npm_config_registry="$NPM_REGISTRY" \
 npm_config_sharp_binary_host="$SHARP_BINARY_HOST" \
 npm_config_sharp_libvips_binary_host="$SHARP_LIBVIPS_BINARY_HOST" \
 npm ci --no-audit --no-fund

COPY . .
RUN mkdir -p /app/public/uploads

RUN NODE_OPTIONS="$BUILD_NODE_OPTIONS" npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]
