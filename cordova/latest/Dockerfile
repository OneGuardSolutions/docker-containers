FROM ubuntu:18.04

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates curl git \
	&& rm -rf /var/lib/apt/lists/* \
	&& curl https://nodejs.org/dist/v4.4.5/node-v4.4.5-linux-x64.tar.gz | \
		tar xz -C /usr/local/ --strip=1 \
	&& npm install -g vue-cli quasar-cli cordova
