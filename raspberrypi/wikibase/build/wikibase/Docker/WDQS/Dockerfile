FROM ubuntu:xenial as fetcher

RUN apt-get update && \
    apt-get install --yes --no-install-recommends unzip=6.* && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ARG tarball
COPY $tarball .
RUN mkdir wdqs-service && \
 tar xfv $tarball -C ./wdqs-service --strip-components=1 \
 && rm $tarball

FROM openjdk:8-slim-buster

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends gettext; \
	rm -rf /var/lib/apt/lists/*; \
	addgroup --gid 66 blazegraph && adduser --system --ingroup blazegraph --uid 666 --shell /bin/bash blazegraph

COPY --from=fetcher --chown=blazegraph:blazegraph /wdqs-service /wdqs

RUN mkdir /var/log/wdqs && chown blazegraph /var/log/wdqs

# Don't set a memory limit otherwise bad things happen (OOMs)
ENV MEMORY=""\
    HEAP_SIZE="1g"\
    HOST="0.0.0.0"\
    WDQS_ENTITY_NAMESPACES="120,122"\
    WIKIBASE_SCHEME="http"\
    WIKIBASE_MAX_DAYS_BACK="90"

WORKDIR /wdqs

COPY --chown=blazegraph:blazegraph wait-for-it.sh entrypoint.sh runBlazegraph.sh runUpdate.sh /
COPY --chown=blazegraph:blazegraph mwservices.json /templates/mwservices.json
COPY --chown=blazegraph:blazegraph RWStore.properties whitelist.txt /wdqs/

# TODO this shouldn't be needed, but CI currently doesnt check for the +x bit, which is why this line is here
RUN chmod +x /wdqs/runUpdate.sh

ENTRYPOINT ["/entrypoint.sh"]
