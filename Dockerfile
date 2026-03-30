# syntax=docker/dockerfile:1

# --build-arg lets CI override the tag; locally you can pin a version
ARG OPENSIPS_TAG=3.4
FROM opensips/opensips:${OPENSIPS_TAG}

LABEL org.opencontainers.image.source="https://github.com/connexcs/connexcs-opensips"
LABEL org.opencontainers.image.description="ConnexCS OpenSIPS with extra modules"

# Copy module list into the image for reference/auditing
COPY modules.env /etc/opensips/custom-modules.env

# Install extra modules declared in modules.env
# Runs as root inside the official image (Debian-based)
RUN apt-get update && \
    grep -v '^\s*#' /etc/opensips/custom-modules.env | \
    grep -v '^\s*$' | \
    xargs apt-get install -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*
