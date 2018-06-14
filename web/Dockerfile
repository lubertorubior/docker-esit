FROM nginx

# Copy nginx configuration
COPY conf /etc/nginx

# Copy site content
COPY content /var/www

# Http
EXPOSE 80
# Https
EXPOSE 443

CMD ["nginx"]
