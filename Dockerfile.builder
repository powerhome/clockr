FROM elixir:1.4

VOLUME /src/clockr

WORKDIR /src/clockr

RUN mix local.hex --force
RUN mix local.rebar --force

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && \
  apt-get install -y nodejs yarn && \
  apt-get autoclean

CMD ./build.sh
