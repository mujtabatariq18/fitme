# ── Stage 1: build Flutter web ────────────────────────────────────────────────
FROM ghcr.io/cirruslabs/flutter:3.44.0 AS build

WORKDIR /app

# Cache deps: copy manifests first, resolve, then copy the rest.
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
# base-href "/" — served at the container root.
RUN flutter build web --release --no-tree-shake-icons

# ── Stage 2: serve with nginx ─────────────────────────────────────────────────
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s \
  CMD wget -q --spider http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
