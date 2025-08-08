FROM debian:bullseye

ARG POSTGRES_DB
ARG POSTGRES_USER
ARG POSTGRES_PASSWORD

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git build-essential libreadline-dev zlib1g-dev flex bison \
    gdb wget curl libssl-dev libicu-dev pkg-config

# Copy Submodule
COPY ./postgres /usr/src/postgres
WORKDIR /usr/src/postgres

# Build with debug symbols
RUN /usr/src/postgres/configure --enable-debug CFLAGS="-O0 -g" && \
    make -j$(nproc) && \
    make install

# Set environment variables for runtime
ENV PATH="/usr/local/pgsql/bin:${PATH}"
ENV PGDATA="/var/lib/postgresql/data"

RUN useradd -m $POSTGRES_USER && \
    mkdir -p $PGDATA && \
    chown -R $POSTGRES_USER:$POSTGRES_USER $PGDATA

# Initialize the database
USER $POSTGRES_USER
RUN initdb -D "$PGDATA" && \
    pg_ctl -D "$PGDATA" start && \
    createdb "$POSTGRES_DB" && \
    psql -d $POSTGRES_DB -c "ALTER USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';" && \
    pg_ctl -D "$PGDATA" stop

EXPOSE 5432

CMD ["postgres", "-D", "/var/lib/postgresql/data"]