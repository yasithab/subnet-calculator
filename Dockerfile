# Use a multi-stage build to keep the final image small and secure
# Set build architecture
ARG ARCH=amd64

# Stage 1: Build the React application
FROM --platform=linux/${ARCH} node:20-alpine as build

# Set arguments for build
ARG REACT_APP_SERVICES_HOST=/services/m

# Set working directory
WORKDIR /app/build

# Copy the application code
COPY . .

# Install dependencies and build the application
RUN npm install \
    && npm run build

# Stage 2: Create a minimal production image using Nginx
FROM --platform=linux/${ARCH} nginxinc/nginx-unprivileged:stable-alpine

# Copy built assets from the build stage
COPY --from=build /app/build/dist /usr/share/nginx/html

# Set a non-root user
USER nginx

# Expose port
EXPOSE 8080

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
