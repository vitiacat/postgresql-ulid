FROM ghcr.io/cloudnative-pg/postgresql:18.1-standard-bookworm
USER root

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/ulid_build

RUN curl -sSL https://github.com/pksunkara/pgx_ulid/releases/download/v0.2.2/pgx_ulid-v0.2.2-pg18-arm64-linux-gnu.deb -o /tmp/ulid18.deb && \
    dpkg -x /tmp/ulid18.deb /tmp/ulid18_files && \
    cp -r /tmp/ulid18_files/usr/lib/postgresql/18/lib/* /usr/lib/postgresql/18/lib/ && \
    cp -r /tmp/ulid18_files/usr/share/postgresql/18/extension/* /usr/share/postgresql/18/extension/

RUN mkdir -p /usr/lib/postgresql/17/lib /usr/share/postgresql/17/extension
RUN curl -sSL https://github.com/pksunkara/pgx_ulid/releases/download/v0.2.2/pgx_ulid-v0.2.2-pg17-arm64-linux-gnu.deb -o /tmp/ulid17.deb && \
    dpkg -x /tmp/ulid17.deb /tmp/ulid17_files && \
    find /tmp/ulid17_files -name "pgx_ulid.so" -exec cp {} /usr/lib/postgresql/17/lib/ \; && \
    find /tmp/ulid17_files -name "ulid*" -exec cp {} /usr/share/postgresql/17/extension/ \;

RUN [ -L /usr/lib/postgresql/18/lib/pgx_ulid.so ] && rm /usr/lib/postgresql/18/lib/pgx_ulid.so || true
RUN cp /usr/lib/postgresql/lib/pgx_ulid.so /usr/lib/postgresql/18/lib/pgx_ulid.so || true

RUN rm -rf /tmp/ulid*
RUN chmod -R 755 /usr/lib/postgresql/17/lib/ /usr/lib/postgresql/18/lib/

USER 26
