ARG BUILD_FROM
FROM $BUILD_FROM

# Install requirements for add-on
# Install MeshCentral
RUN mkdir -p /opt/meshcentral \
    && cd /opt/meshcentral

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
