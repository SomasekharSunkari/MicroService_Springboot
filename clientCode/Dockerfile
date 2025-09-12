# ---------- STAGE 1: Build ----------
FROM public.ecr.aws/docker/library/node:20-alpine AS build
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy source code and build
COPY . .
RUN npm run build

# ---------- STAGE 2: Run ----------
FROM public.ecr.aws/docker/library/nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy build artifacts from builder
COPY --from=build /app/dist .

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
