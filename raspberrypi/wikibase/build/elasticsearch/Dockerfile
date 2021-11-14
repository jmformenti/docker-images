FROM carlosedp/docker-elasticsearch:6.5.4

ENV NODE_NAME=elastic

ENV ELASTICSEARCH_CONF_DIR /elasticsearch/config

RUN set -eux; \
	sed -i "s/.*network\.host:.*/network\.host: 0.0.0.0/" $ELASTICSEARCH_CONF_DIR/elasticsearch.yml; \
	sed -i -e '$adiscovery.type: single-node\' $ELASTICSEARCH_CONF_DIR/elasticsearch.yml;
