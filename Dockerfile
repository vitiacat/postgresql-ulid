FROM ghcr.io/cloudnative-pg/postgresql:18.1-standard-bookworm
USER root
RUN apt-get update && apt-get install -y curl && curl -sSL https://github.com/pksunkara/pgx_ulid/releases/download/v0.2.2/pgx_ulid-v0.2.2-pg18-arm64-linux-gnu.deb -o pgx_ulid.deb && dpkg -i pgx_ulid.deb && rm pgx_ulid.deb && rm -rf /var/lib/apt/lists/*
RUN rm /usr/lib/postgresql/18/lib/pgx_ulid.so && \
    cp /usr/lib/postgresql/lib/pgx_ulid.so /usr/lib/postgresql/18/lib/pgx_ulid.so
RUN chmod 755 /usr/lib/postgresql/18/lib/pgx_ulid.so
USER 26
