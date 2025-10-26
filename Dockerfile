FROM matomo:latest

USER root

# Install cron
RUN apt-get update && apt-get install -y cron && rm -rf /var/lib/apt/lists/*

# Copy cron job file
COPY matomo-cron /etc/cron.d/matomo-cron

# Give execution rights on the cron job and apply it
RUN chmod 0644 /etc/cron.d/matomo-cron && \
    crontab -u www-data /etc/cron.d/matomo-cron

# Create entrypoint script to start cron and the main process
RUN echo '#!/bin/bash\n\
cron\n\
exec /entrypoint.sh "$@"' > /usr/local/bin/custom-entrypoint.sh && \
    chmod +x /usr/local/bin/custom-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["apache2-foreground"]
