FROM ubuntu:22.04

# Update repo 
RUN apt-get update

# Install openssl

# Ngnix install and config
RUN apt install -y nginx

# Create directories for public and protected pages
RUN mkdir -p /var/www/public /var/www/protected

# Copy the public and protected pages to the respective directories
COPY pages/public_page/ /var/www/public
COPY pages/protected_page/ /var/www/protected

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Create the htpasswd file for basic authentication
RUN --mount=type=secret,id=private_user_password,target=/run/secrets/private_user_password \ 
    echo "private_user:$(cat /run/secrets/private_user_password | openssl passwd -6 -stdin)" > /etc/nginx/.htpasswd


# Expose ports
EXPOSE 80
EXPOSE 443

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]