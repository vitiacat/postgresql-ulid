FROM ghcr.io/cloudnative-pg/postgresql:18.1-standard-bookworm
USER root

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://github.com/pksunkara/pgx_ulid/releases/download/v0.2.2/pgx_ulid-v0.2.2-pg18-arm64-linux-gnu.deb -o pgx_ulid_18.deb && \
    dpkg -i pgx_ulid_18.deb && \
    rm pgx_ulid_18.deb
RUN rm /usr/lib/postgresql/18/lib/pgx_ulid.so && \
    cp /usr/lib/postgresql/lib/pgx_ulid.so /usr/lib/postgresql/18/lib/pgx_ulid.so

RUN mkdir -p /usr/lib/postgresql/17/lib

RUN curl -sSL https://github.com/pksunkara/pgx_ulid/releases/download/v0.2.2/pgx_ulid-v0.2.2-pg17-arm64-linux-gnu.deb -o pgx_ulid_17.deb

RUN dpkg -x pgx_ulid_17.deb /tmp/pg17_ext

RUN find /tmp/pg17_ext -name "pgx_ulid.so" -exec cp {} /usr/lib/postgresql/17/lib/ \;

RUN rm pgx_ulid_17.deb && rm -rf /tmp/pg17_ext

RUN chmod 755 /usr/lib/postgresql/18/lib/pgx_ulid.so && \
    chmod 755 /usr/lib/postgresql/17/lib/pgx_ulid.so

USER 26
