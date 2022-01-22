FROM docker-registry.wikimedia.org/composer-scratch as composer

FROM docker-registry.wikimedia.org/php74

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Grab our composer helper scripts
COPY --from=composer /srv/composer /srv/composer

USER root

RUN apt-get install -y jq

USER nobody

ENTRYPOINT ["/srv/composer/run-composer.sh"]
CMD ["help"]
