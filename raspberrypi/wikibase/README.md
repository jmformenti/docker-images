# Wikibase for ARM 64 bits

Steps to generate from scratch a Wikibase docker image for ARM 64 bits using official Wikimedia repos.

All this steps have been executed in a Raspberry PI 4B with [Raspbian OS 64 bits](https://downloads.raspberrypi.org/raspios_arm64/images/) and [docker >= 20.4](https://dev.to/elalemanyo/how-to-install-docker-and-docker-compose-on-raspberry-pi-1mo).

## Build images

### Prepare build environment

1. Login as pi user, create a working base dir and clone this repo:
```
mkdir project
cd project
git clone https://github.com/jmformenti/docker-images.git
```

### Build base images

1. Clone repo:
```
cd ~/project
git clone "https://gerrit.wikimedia.org/r/operations/puppet"
```
2. Comment unnecessary lines in build base docker images script. Copy adapted build script.
```
cp ~/project/docker-images/raspberrypi/wikibase/build/base/build-bare-slim.sh ~/project/puppet/modules/docker/files
```
3. Prepare build execution.
```
sudo apt install debuerreotype
cp ~/project/puppet/modules/docker/files/Dockerfile.slim ~/project/wikibase64/build/files/Dockerfile
export REGISTRY=docker-registry.wikimedia.org
export SRCDIR=~/project/docker-images/raspberrypi/wikibase/build/base/files
```
4. Build locally our Debian `strech` base image.
```
sudo -E ~/project/puppet/modules/docker/files/build-bare-slim.sh stretch
```
5. Build locally our Debian `buster` base image.
```
sudo -E ~/project/puppet/modules/docker/files/build-bare-slim.sh buster
```
6. Check that images `docker-registry.wikimedia.org/stretch` and `docker-registry.wikimedia.org/buster` exists.
```
docker images
```

### Build required CI images

The goal here is get `composer-php73` docker image, required to build final Wikibase image.

1. Clone repo:
```
cd ~/project
git clone "https://gerrit.wikimedia.org/r/integration/config"
```
2. Copy adapted `Dockerfile`s inside `config` repo. These `Dockerfile`s have been generated from original `Dockerfile.template`s.
```
cp -r ~/project/docker-images/raspberrypi/wikibase/build/ci/* ~/project/config/dockerfiles/
```
3. Build locally our CI images.
```
cd ~/project/config/dockerfiles/ci-common
docker build -t docker-registry.wikimedia.org/ci-common .
cd ../ci-stretch
docker build -t docker-registry.wikimedia.org/ci-stretch .
cd ../ci-buster
docker build -t docker-registry.wikimedia.org/ci-buster .
cd ../sury-php
docker build -t docker-registry.wikimedia.org/sury-php .
cd ../php73
docker build -t docker-registry.wikimedia.org/php73 .
cd ../composer-scratch
docker build -t docker-registry.wikimedia.org/composer-scratch .
cd ../composer-php73
docker build -t docker-registry.wikimedia.org/releng/composer-php73 .
```
4. Check that image `docker-registry.wikimedia.org/composer-php73` exists.
```
docker images
```

### Build Wikibase

1. Generate Wikibase docker image [building](https://github.com/wmde/wikibase-release-pipeline/blob/main/docs/topics/pipeline.md) from [wikibase-release-pipeline](https://github.com/wmde/wikibase-release-pipeline).
```
cd ~/project
git clone https://github.com/wmde/wikibase-release-pipeline.git
cd wikibase-release-pipeline
./build.sh wikibase versions/wmde2.env
```
2. Check that image `wikibase` exists.
```
docker images
```

## Run Wikibase

Run a Wikibase instance using [docker-compose](https://dev.to/elalemanyo/how-to-install-docker-and-docker-compose-on-raspberry-pi-1mo#4-install-dockercompose).

1. Prepare environment variables file with properly docker images names.
```
cp ~/project/docker-images/raspberrypi/wikibase/run/template.env ~/project/wikibase-release-pipeline/example/.env
```
2. Configure variables in `.env` (like `MW_ADMIN_PASS`, `DB_PASS` ..)
3. Run.
```
cd ~/project/wikibase-release-pipeline/example
docker-compose up -d
```
4. Access to your Wikibase instance (it takes a while to boot up completely): http://<host>
