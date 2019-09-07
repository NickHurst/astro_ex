FROM elixir:alpine as common

ENV ROOT=/astro_ex USER=astro_ex GROUP=users

RUN apk add git && \
  adduser -S -G ${GROUP} ${USER} && \
  mkdir ${ROOT} && \
  chown -R ${USER}:${GROUP} ${ROOT}

USER ${USER}
WORKDIR ${ROOT}

RUN mix local.hex --force && \
  mix local.rebar --force

COPY mix.* ${ROOT}/
COPY config ${ROOT}/config

CMD iex -S mix

FROM common as build-env

ARG MIX_ENV=test

RUN mix deps.get && mix deps.compile

COPY --chown=astro_ex:users . ${ROOT}

RUN mix compile
