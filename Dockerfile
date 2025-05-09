# Use Nginx as the base image
FROM nginx:alpine

# Copy static website files to Nginx's serving directory
COPY . /usr/share/nginx/html

# Remove any files that shouldn't be in the web root (optional)
RUN rm -f /usr/share/nginx/html/Dockerfile /usr/share/nginx/html/docker-compose.yml 2>/dev/null || true

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
