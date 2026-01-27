ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements for add-on
RUN \
  apk add --no-cache \
    npm \
    jq

# Install MeshCentral
WORKDIR /opt/meshcentral
ARG BUILD_VERSION
RUN \
    npm install meshcentral@${BUILD_VERSION%-*} \
    && npm audit fix \
    # Remove cache \
    && rm -rf /root/.npm

# Make common folders persistent
RUN \
  for f in data backups files; do ln -sfn /data/meshcentral-${f}; done

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
