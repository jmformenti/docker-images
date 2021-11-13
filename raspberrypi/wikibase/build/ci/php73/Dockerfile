FROM docker-registry.wikimedia.org/sury-php

# zip is needed for composer to install things from dist
# others are libraries/MediaWiki related
##{% set packages|replace('\n', ' ') -%}
##php7.3-cli
##php7.3-zip
##php-ast
##php7.3-bcmath
##php7.3-curl
##php7.3-dba
##php7.3-gd
##php7.3-gmp
##php7.3-intl
##php7.3-mbstring
##php-redis
##php7.3-sqlite3
##php-xdebug
##php7.3-xml
##zip
##unzip
##s{%- endset -%}

RUN apt-get update \
 && apt-get -y install php7.3-cli php7.3-zip php-ast php7.3-bcmath php7.3-curl php7.3-dba php7.3-gd php7.3-gmp php7.3-intl php7.3-mbstring php-redis php7.3-sqlite3 php-xdebug php7.3-xml zip unzip


# Disable xdebug by default due to its performance impact
RUN phpdismod xdebug

USER nobody

ENTRYPOINT ["php"]
CMD ["--help"]
