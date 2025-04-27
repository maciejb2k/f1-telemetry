FROM ruby:3.3.5

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID appuser && useradd -m -u $UID -g $GID appuser

USER appuser

ENV BUNDLE_PATH=/home/appuser/.bundle
ENV BUNDLE_HOME=/home/appuser/.bundle
ENV GEM_HOME=/home/appuser/.bundle
ENV PATH=$GEM_HOME/bin:$PATH

RUN gem install bundler

USER root

COPY Gemfile Gemfile.lock ./

RUN chown -R appuser:appuser /app

USER appuser

RUN bundle install

COPY . .

CMD bash -c "rm -f tmp/pids/server.pid && bin/rails s -p 3000 -b '0.0.0.0'"
