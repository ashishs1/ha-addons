ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
#SHELL ["/bin/sh", "-c"]

# Home Assistant requires these labels
#LABEL \
#    io.hass.name="Memos" \
#    io.hass.description="note-taking service" \
#    io.hass.version="${BUILD_VERSION}" \
#    io.hass.type="addon" \
#    io.hass.arch="${BUILD_ARCH}"

HEALTHCHECK --interval=60s --timeout=5s --start-period=40s \
  CMD wget -q --spider http://127.0.0.1:5230/api/health || exit 1

#ENTRYPOINT [ "/run.sh" ]
