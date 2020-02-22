FROM atypical/rpi/java:11-buster

ENV ELASTICSEARCH_VERSION 7.6.0
ENV ELASTICSEARCH_BASE_URL https://artifacts.elastic.co/downloads/elasticsearch
ENV ELASTICSEARCH_DIR /opt/elasticsearch-$ELASTICSEARCH_VERSION
ENV ELASTICSEARCH_CONF_DIR $ELASTICSEARCH_DIR/config
ENV ELASTICSEARCH_JAVA_HEAP 256m

RUN set -eux; \
	wget -O elasticsearch.tgz "${ELASTICSEARCH_BASE_URL}/elasticsearch-oss-$ELASTICSEARCH_VERSION-no-jdk-linux-x86_64.tar.gz" --progress=dot:giga; \
	mkdir -p "$ELASTICSEARCH_DIR"; \
	tar --extract \
		--file elasticsearch.tgz \
		--directory "$ELASTICSEARCH_DIR" \
		--strip-components 1 \
		--no-same-owner \
	; \
	rm elasticsearch.tgz;

RUN set -eux; \
	sed -i "s/-Xms.*/-Xms$ELASTICSEARCH_JAVA_HEAP/" $ELASTICSEARCH_CONF_DIR/jvm.options; \
	sed -i "s/-Xmx.*/-Xmx$ELASTICSEARCH_JAVA_HEAP/" $ELASTICSEARCH_CONF_DIR/jvm.options; \
	sed -i "s/.*network\.host:.*/network\.host: 0.0.0.0/" $ELASTICSEARCH_CONF_DIR/elasticsearch.yml; \
	sed -i -e '$adiscovery.type: single-node\' $ELASTICSEARCH_CONF_DIR/elasticsearch.yml; \
	sed -i -e '$abootstrap.system_call_filter: false\' $ELASTICSEARCH_CONF_DIR/elasticsearch.yml;

WORKDIR $ELASTICSEARCH_DIR

RUN bin/elasticsearch-plugin install --batch ingest-attachment

EXPOSE 9200 9300

ENTRYPOINT [ "bin/elasticsearch" ]
