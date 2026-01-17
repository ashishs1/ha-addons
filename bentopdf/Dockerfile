ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements for add-on
RUN \
  apk add --no-cache \
    npm \
    curl \
    unzip \
    git

WORKDIR /opt/bentopdf

ARG BENTOPDF_VERSION=1.16.0

# Download & install bentopdf
RUN \
  #curl -LO https://github.com/alam00000/bentopdf/releases/download/v${BENTOPDF_VERSION}/dist-${BENTOPDF_VERSION}.zip \
  #&& unzip dist-${BENTOPDF_VERSION}.zip \
  #&& rm dist-${BENTOPDF_VERSION}.zip \
  git clone https://github.com/alam00000/bentopdf.git --branch v${BENTOPDF_VERSION} \
  && cd bentopdf \
  && npm install \
  && npm audit fix || true \
  && SIMPLE_MODE=true npm run build

RUN \
  npm install -g http-server \
  && npm prune --omit=dev \
  && mv dist/* ../ \
  && cd .. \
  && rm -rf bentopdf \
  # Clear cache in root also (~400MB) \
  && rm -rf /root/.npm \
  && apk del unzip git

# Copy data for add-on
# COPY rootfs/ /
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

