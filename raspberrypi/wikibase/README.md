# Wikibase for ARM 64 bits

Steps to generate from scratch a Wikibase docker image for ARM 64 bits using official Wikimedia repos.

All this steps have been executed in a Raspberry PI 4B with [Raspbian OS 64 bits](https://downloads.raspberrypi.org/raspios_arm64/images/) and [docker >= 20.4](https://dev.to/elalemanyo/how-to-install-docker-and-docker-compose-on-raspberry-pi-1mo).

Based on the  Wikimedia Deutschland [wikibase-release-pipeline](https://github.com/wmde/wikibase-release-pipeline) repo.

## Build and run from scratch

### Build images

#### Prepare build environment

1. Login as `pi` user, create a working base dir and clone this repo:
```
mkdir project
cd project
git clone https://github.com/jmformenti/docker-images.git
```

#### Build base images

1. Clone repo:
```
cd ~/project
git clone https://gerrit.wikimedia.org/r/operations/puppet
```
2. Comment unnecessary lines in build base docker images script. Copy adapted build script.
```
cp ~/project/docker-images/raspberrypi/wikibase/build/base/build-bare-slim.sh ~/project/puppet/modules/docker/files
```
3. Prepare build execution.
```
sudo apt install debuerreotype
cp ~/project/puppet/modules/docker/files/Dockerfile.slim ~/project/docker-images/raspberrypi/wikibase/build/base/files/Dockerfile
export REGISTRY=docker-registry.wikimedia.org
export SRCDIR=~/project/docker-images/raspberrypi/wikibase/build/base/files
```
4. Build locally our Debian `buster` base image.
```
sudo -E ~/project/puppet/modules/docker/files/build-bare-slim.sh buster
```
5. Check that image `docker-registry.wikimedia.org/buster` exists.
```
docker images
```

#### Build required CI images

The goal here is get `composer-php73` docker image, required to build final Wikibase image.

1. Clone repo:
```
cd ~/project
git clone https://gerrit.wikimedia.org/r/integration/config
```
2. Copy adapted `Dockerfile`s inside `config` repo. These `Dockerfile`s have been generated from original `Dockerfile.template`s.
```
cp -r ~/project/docker-images/raspberrypi/wikibase/build/ci/* ~/project/config/dockerfiles/
```
3. Build locally our CI images.
```
cd ~/project/config/dockerfiles/ci-common
docker build -t docker-registry.wikimedia.org/ci-common .
cd ../ci-buster
docker build -t docker-registry.wikimedia.org/ci-buster .
cd ../sury-php
docker build -t docker-registry.wikimedia.org/sury-php .
cd ../composer-scratch
docker build -t docker-registry.wikimedia.org/composer-scratch .
cd ../php74
docker build -t docker-registry.wikimedia.org/php74 .
cd ../composer-php74
docker build -t docker-registry.wikimedia.org/releng/composer-php74 .
```
4. Check that image `docker-registry.wikimedia.org/composer-php74` exists.
```
docker images
```

#### Build Wikibase and extras

The goal here is build docker images for Wikibase, Elasticsearch, WDQS and QuickStatements.

1. Generate Elasticsearch image.
```
cd ~/project/docker-images/raspberrypi/wikibase/build/elasticsearch
docker build -t elasticsearch:6.5.4 .
```
2. Prepare to build Wikibase docker image [building](https://github.com/wmde/wikibase-release-pipeline/blob/main/docs/topics/pipeline.md) from [wikibase-release-pipeline](https://github.com/wmde/wikibase-release-pipeline).
```
cd ~/project
git clone https://github.com/wmde/wikibase-release-pipeline.git
cp ~/project/docker-images/raspberrypi/wikibase/build/wikibase/local.env ~/project/wikibase-release-pipeline
```
3. Update wikibase docker files.
```
cp -r ~/project/docker-images/raspberrypi/wikibase/build/wikibase/Docker/* ~/project/wikibase-release-pipeline/Docker/build/
```
4. Generate Wikibase docker image [building](https://github.com/wmde/wikibase-release-pipeline/blob/main/docs/topics/pipeline.md) from [wikibase-release-pipeline](https://github.com/wmde/wikibase-release-pipeline).
```
cd ~/project/wikibase-release-pipeline
./build.sh all versions/wmde4.env
```
5. Check that image `wikibase` and extras exists.
```
docker images
```

### Run

Run a Wikibase using [docker-compose](https://dev.to/elalemanyo/how-to-install-docker-and-docker-compose-on-raspberry-pi-1mo#4-install-dockercompose).

#### Prepare run environment

1. Create a dir where keep docker-compose config for wikibase (f.e.: `~/docker/wikibase`).
```
mkdir -p ~/docker/wikibase
cp ~/project/wikibase-release-pipeline/example/* ~/docker/wikibase
cp ~/project/docker-images/raspberrypi/wikibase/run/template.env ~/docker/wikibase/.env
```
2. Configure variables in `~/docker/wikibase/.env` (like `MW_ADMIN_PASS`, `DB_PASS` ..)

#### Wikibase instance

Here we run only a Wikibase instance without any extra tool.

1. Run.
```
cd ~/docker/wikibase
docker-compose up -d
```
2. Access to your Wikibase instance (it takes a while to boot up completely): http://<host>
3. Stop.
```
cd ~/docker/wikibase
docker-compose stop
```
4. Remove.
```
cd ~/docker/wikibase
docker-compose down -v
```

#### Wikibase and extras

Here we run a Wikibase instance with Elasticsearch, WDQS and QuickStatements.

1. Run.
```
cd ~/docker/wikibase
docker-compose -f docker-compose.yml -f docker-compose.extra.yml up -d
```
2. Access to your Wikibase instance (it takes a while to boot up completely): 
  * Wikibase: http://[host]
  * WDQS: http://[host]:8834
  * QuickStatements: http://[host]:8840
3. Stop.
```
cd ~/docker/wikibase
docker-compose -f docker-compose.yml -f docker-compose.extra.yml stop
```
4. Remove.
```
cd ~/docker/wikibase
docker-compose -f docker-compose.yml -f docker-compose.extra.yml down -v
```

## Futher work

Try to minimize WDQS docker image using [UBI minimal image for java 8](https://catalog.redhat.com/software/containers/ubi8/openjdk-8/5dd6a48dbed8bd164a09589a?architecture=arm64).
