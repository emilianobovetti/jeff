FROM debian:stable-slim as curaengine

ENV CURAENGINE_VERSION="5.4.0" \
  CURA_VERSION="5.4.0" \
  DEBIAN_FRONTEND=noninteractive \
  LANG=C.UTF-8

RUN set -xe \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    git \
    cmake \
    ninja-build \
    gcc \
    g++ \
    libc6-dev \
  && mkdir -p /opt/curaengine \
  && CURAENGINE_DOWNLOAD_URL="https://github.com/Ultimaker/CuraEngine/archive/$CURAENGINE_VERSION.tar.gz" \
  && CURAENGINE_DOWNLOAD_SHA256="202a2183355d96c28f45299688b78975c2bc8f7043e8885cf17c1eb3e5d09709" \
  && curl -fSL -o /tmp/curaengine.tar.gz "$CURAENGINE_DOWNLOAD_URL" \
  && echo "$CURAENGINE_DOWNLOAD_SHA256  /tmp/curaengine.tar.gz" | sha256sum -c - \
  && tar -xf /tmp/curaengine.tar.gz --directory /opt/curaengine --strip-components=1 \
  && rm /tmp/curaengine.tar.gz \
  && ( cd /opt/curaengine \
    && python3 -m venv venv \
    && . venv/bin/activate \
    && pip install conan==1.60 \
    && conan config install https://github.com/ultimaker/conan-config.git \
    && conan install . --build=missing --update \
    && cmake --preset release \
    && cmake --build --preset release \
    && mkdir -p /opt/out/bin \
    && mkdir -p /opt/out/lib \
    && cd /opt/curaengine/build/Release \
    && cp CuraEngine /opt/out/bin/ \
    && cp $(ldd CuraEngine | awk 'NF == 4 && $3 ~ /^\/root\/.conan/ {print $3}') /opt/out/lib/ ) \
  && CURA_DOWNLOAD_URL="https://github.com/Ultimaker/Cura/archive/$CURA_VERSION.tar.gz" \
  && CURA_DOWNLOAD_SHA256="0be74be2c3e7b41974bec13a9e1cb596fa747e7925987d7670c9f4832cba6f49" \
  && mkdir -p /opt/cura \
  && curl -fSL -o /tmp/cura.tar.gz "$CURA_DOWNLOAD_URL" \
  && echo "$CURA_DOWNLOAD_SHA256  /tmp/cura.tar.gz" | sha256sum -c - \
  && tar -xf /tmp/cura.tar.gz --directory /opt/cura --strip-components=1 \
  && rm /tmp/cura.tar.gz \
  && mkdir -p /opt/out/resources \
  && cp -r /opt/cura/resources/definitions /opt/cura/resources/extruders /opt/out/resources/ \
  && rm -rf /opt/curaengine /opt/cura ~/.conan /var/lib/apt/lists/*

FROM debian:stable-slim as erlang

COPY --from=erlang:26-slim \
  /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 \
  /usr/lib/x86_64-linux-gnu/libssl.so.1.1 \
  /usr/lib/x86_64-linux-gnu/

COPY --from=erlang:26-slim \
  /usr/lib/x86_64-linux-gnu/engines-1.1/afalg.so \
  /usr/lib/x86_64-linux-gnu/engines-1.1/padlock.so \
  /usr/lib/x86_64-linux-gnu/engines-1.1/

COPY --from=erlang:26-slim \
  /usr/local/bin/rebar3 \
  /usr/local/bin/

COPY --from=erlang:26-slim \
  /usr/local/lib/erlang/ \
  /usr/local/lib/erlang/

RUN set -xe \
  && for name in ct_run dialyzer epmd erl erlc escript run_erl to_erl typer; do \
      ln -s /usr/local/lib/erlang/bin/$name /usr/local/bin/$name; \
    done

FROM erlang as elixir

COPY --from=elixir:1.15-slim \
  /usr/local/lib/elixir/ \
  /usr/local/lib/elixir/

COPY --from=elixir:1.15-slim \
  /usr/local/share/man/man1/elixir.1 \
  /usr/local/share/man/man1/elixirc.1 \
  /usr/local/share/man/man1/iex.1 \
  /usr/local/share/man/man1/mix.1 \
  /usr/local/share/man/man1/

RUN set -xe \
  && for name in elixir elixirc iex mix; do \
      ln -s /usr/local/lib/elixir/bin/$name /usr/local/bin/$name; \
    done

FROM elixir as dev

ENV DEBIAN_FRONTEND=noninteractive \
  LANG=C.UTF-8

ARG UID=1000
ARG GID=1000

RUN set -xe \
  && groupadd --gid "$GID" app \
  && useradd --create-home --home-dir /home/app --uid "$UID" --gid "$GID" app \
  && apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates inotify-tools

COPY --from=curaengine \
  /opt/out/bin/CuraEngine \
  /usr/local/bin/

COPY --from=curaengine \
  /opt/out/lib/libArcus.so \
  /opt/out/lib/libpolyclipping.so.22 \
  /opt/out/lib/libprotobuf.so.32 \
  /lib/x86_64-linux-gnu/

COPY --from=curaengine \
  /opt/out/resources/ \
  /opt/cura/resources/

WORKDIR /home/app

USER app

RUN set -xe \
  && mix local.hex --force \
  && mix local.rebar --force

ENTRYPOINT ["sh", "-c", "[ $# -eq 0 ] && exec mix start || exec $@", "$@"]

FROM elixir AS build

ENV DEBIAN_FRONTEND=noninteractive \
  LANG=C.UTF-8 \
  MIX_ENV=prod

RUN set -xe \
  && apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/app

COPY mix.exs mix.lock ./

RUN mix do deps.get, deps.compile

COPY lib lib/

RUN mix release

FROM debian:stable-slim AS deploy

ENV LANG=C.UTF-8

COPY --from=erlang:26-slim \
  /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 \
  /usr/lib/x86_64-linux-gnu/libssl.so.1.1 \
  /usr/lib/x86_64-linux-gnu/

COPY --from=erlang:26-slim \
  /usr/lib/x86_64-linux-gnu/engines-1.1/afalg.so \
  /usr/lib/x86_64-linux-gnu/engines-1.1/padlock.so \
  /usr/lib/x86_64-linux-gnu/engines-1.1/

COPY --from=curaengine \
  /opt/out/bin/CuraEngine \
  /usr/local/bin/

COPY --from=curaengine \
  /opt/out/lib/libArcus.so \
  /opt/out/lib/libpolyclipping.so.22 \
  /opt/out/lib/libprotobuf.so.32 \
  /lib/x86_64-linux-gnu/

COPY --from=curaengine \
  /opt/out/resources/ \
  /opt/cura/resources/

COPY --from=build \
  /opt/app/_build/prod/rel/deploy \
  /usr/local/lib/jeff

ENTRYPOINT ["/usr/local/lib/jeff/bin/deploy", "start"]
