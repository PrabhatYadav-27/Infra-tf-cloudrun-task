# Use the official httpd image from the Docker Hub
FROM httpd:latest

# Copy your website files into the appropriate directory in the container
RUN echo 'Hello World' > /usr/local/apache2/htdocs/index.html

# Expose port 80
EXPOSE 80

# Start the httpd server
CMD ["httpd-foreground"]