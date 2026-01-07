ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements for add-on
RUN \
  apk add --no-cache \
    npm \
    curl \
    unzip \
    nginx

WORKDIR /opt/bentopdf

# Download & install bentopdf
RUN \
  curl -LO https://github.com/alam00000/bentopdf/releases/download/v1.15.4/dist-1.15.4.zip \
  && unzip dist-1.15.4.zip \
  && rm dist-1.15.4.zip \
  && apk del unzip \
  && npm install http-server

# Copy data for add-on
# COPY rootfs/ /
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

