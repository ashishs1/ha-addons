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

ARG BUILD_VERSION

# Download & install bentopdf
RUN \
  git clone https://github.com/alam00000/bentopdf.git --branch v${BUILD_VERSION} . \
  && npm install \
  && npm audit fix || true \
  && SIMPLE_MODE=true npm run build \
  && npm install -g http-server \
  && npm prune --omit=dev \
  && mv dist ../ \
  && cd .. \
  && rm -rf bentopdf \
  && mkdir bentopdf \
  && mv dist bentopdf/ \
  # Clear cache in root also (~400MB) \
  && rm -rf /root/.npm \
  && apk del unzip git

# Copy data for add-on
# COPY rootfs/ /
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

