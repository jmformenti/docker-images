docker tag wikibase:latest jmformenti/wikibase:1.36.3-wmde.4
docker push jmformenti/wikibase:1.36.3-wmde.4
docker tag wdqs:latest jmformenti/wdqs:0.3.97-wmde.4
docker push jmformenti/wdqs:0.3.97-wmde.4
docker tag wdqs-frontend:latest jmformenti/wdqs-frontend:wmde.4
docker push jmformenti/wdqs-frontend:wmde.4
docker tag wikibase/elasticsearch:latest jmformenti/elasticsearch-wikibase:6.5.4-wmde.4
docker push jmformenti/elasticsearch-wikibase:6.5.4-wmde.4
docker tag wikibase-bundle:latest jmformenti/wikibase-bundle:1.36.3-wmde.4
docker push jmformenti/wikibase-bundle:1.36.3-wmde.4
docker tag quickstatements:latest jmformenti/quickstatements:wmde.4
docker push jmformenti/quickstatements:wmde.4
docker tag wdqs-proxy:latest jmformenti/wdqs-proxy:wmde.4
docker push jmformenti/wdqs-proxy:wmde.4

