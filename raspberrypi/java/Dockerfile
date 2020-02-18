FROM debian:buster

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		wget \
		ca-certificates \
	; \
	rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

ENV JAVA_VERSION 11.0.6_10
ENV JAVA_BASE_URL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jdk_arm_linux_hotspot
ENV JAVA_HOME /opt/jdk-$JAVA_VERSION
ENV PATH $JAVA_HOME/bin:$PATH

RUN set -eux; \
	wget -O openjdk.tgz "${JAVA_BASE_URL}_${JAVA_VERSION}.tar.gz" --progress=dot:giga; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract \
		--file openjdk.tgz \
		--directory "$JAVA_HOME" \
		--strip-components 1 \
		--no-same-owner \
	; \
	rm openjdk.tgz*; \
	\
	java --version
