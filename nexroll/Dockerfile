# NeXroll Home Assistant Add-on
# NeXroll Home Assistant Add-on
# Extends the official NeXroll Docker image and adds HA-specific plumbing.
#
# Upstream image: https://hub.docker.com/r/jbrns/nexroll
# Upstream source: https://github.com/JFLXCLOUD/NeXroll

FROM jbrns/nexroll:2.0.4

# jq is needed to parse /data/options.json (HA's options file)
RUN apt-get update \
    && apt-get install -y --no-install-recommends jq \
    && rm -rf /var/lib/apt/lists/*

# Copy our HA-aware startup wrapper
COPY run.sh /run.sh
RUN chmod a+x /run.sh

WORKDIR /app/NeXroll

CMD ["/run.sh"]
