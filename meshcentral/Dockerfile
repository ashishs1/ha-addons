ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements for add-on
RUN \
  apk add --no-cache \
    npm \
    jq

# Install MeshCentral
RUN mkdir -p /opt/meshcentral \
    && cd /opt/meshcentral \
    && npm install meshcentral

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
