# Example docker-compose configuration

Example of docker-compose configuration to run Wikibase on ARM 64bits.

Based on [wikibase-release-pipeline repo](https://github.com/wmde/wikibase-release-pipeline).

Follow instructions [here](https://github.com/wmde/wikibase-release-pipeline/tree/main/example) using my template.env, only has changed docker images to point my ARM 64bits version.

**IMPORTANT**: In docker-compose.extra.xml change volume mapping in elasticsearch container, from
```
- elasticsearch-data:/usr/share/elasticsearch/data
```
to
```
- elasticsearch-data:/data
```
