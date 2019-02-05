FROM phusion/baseimage:0.11

LABEL description="Devspaces implementation for Rails Active Job"

# Install deps
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    htop \
    mc \
    make \
    nodejs \
    netbase \
    redis-server \
    socat \
    wget \
    tzdata \
    vim  && \
    rm -rf /var/lib/apt/lists/*

# Set UTF-8 locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LANG="en_US.UTF-8" \
    LC_NUMERIC="POSIX" \
    LC_MESSAGES="POSIX"

#
# Install ruby
#
ENV RUBY_VERSION 2.3.7
COPY assets/scripts/install_ruby /opt/devspaces/install_ruby
RUN chmod +x /opt/devspaces/install_ruby && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install \
    libssl1.0-dev \
    libreadline-dev \
    zlib1g-dev && \
    /opt/devspaces/install_ruby ${RUBY_VERSION} && \
    rm -rf /var/lib/apt/lists/*

#
# Install postgres
#
ENV PG_VERSION  9.6
ENV PG_ETC      /etc/postgresql/${PG_VERSION}/main
ENV PG_DIR      /var/lib/postgresql
ENV PG_DATA     ${PG_DIR}/data
ENV PATH        ${PG_DIR}/${PG_VERSION}/bin:$PATH

# Create  postgres user, add repos and install postgres.
RUN set -eux; \
    groupadd -r postgres --gid=999; \
    useradd -r -g postgres --uid=999 --home-dir=${PG_DIR} --shell=/bin/bash postgres; \
    mkdir -p ${PG_DIR}; \
    chown -R postgres:postgres ${PG_DIR}; \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' ; \
    wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add - ; \
    apt-get update ; \
    apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages install \
    postgresql-${PG_VERSION} postgresql-contrib-${PG_VERSION} libpq-dev ; \
    rm -rf /var/lib/apt/lists/*

#
# Install Image scripts
#
COPY assets/entrypoint.sh /opt/devspaces/entrypoint.sh
RUN chmod +x /opt/devspaces/entrypoint.sh

#
# Install services
#
COPY assets/services /etc/service
RUN chmod +x /etc/service/postgres/run && \
    chmod +x /etc/service/postgres/log/run && \
    chmod +x /etc/service/redis/run && \
    chmod +x /etc/service/redis/log/run

#
# Copy default configs
#
ADD assets/configs.zip /tmp/configs.zip
RUN unzip /tmp/configs.zip -d /opt/devspaces && \
    rm /tmp/configs.zip

#
# Configure redis
#
RUN sed -i "s/bind 127.0.0.1 ::1/bind 127.0.0.1/g" /etc/redis/redis.conf

WORKDIR /data

EXPOSE 3000

ENTRYPOINT /opt/devspaces/entrypoint.sh

CMD tail -f /dev/null
