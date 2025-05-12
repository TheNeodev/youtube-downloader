# Use the official Bun image for building
FROM oven/bun:1.2 as builder
WORKDIR /app
COPY . .
RUN bun install --frozen-lockfile && bun run build

# Use Nginx to serve the build output statically
FROM nginx:alpine as production
COPY --from=builder /app/dist /usr/share/nginx/html
# Custom nginx config to support client-side routing
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
