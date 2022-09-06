ARG ELIXIR_VERSION=1.13.4
ARG OTP_VERSION=25.0.4
ARG ALPINE_VERSION=3.16.1

FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-alpine-${ALPINE_VERSION} as builder

WORKDIR /app

RUN mix local.hex --force \
 && mix local.rebar --force

ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY lib lib
COPY priv priv

RUN mix release

FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
  curl \
  libstdc++ \
  ncurses-libs

WORKDIR /app
RUN chown nobody /app

ENV MIX_ENV=prod
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/apns_mock ./

USER nobody

ENV PHX_SERVER=true

HEALTHCHECK \
  CMD curl --fail --insecure --silent --show-error https://localhost:2197/healthcheck

ENTRYPOINT ["/app/bin/apns_mock"]
CMD ["start"]
