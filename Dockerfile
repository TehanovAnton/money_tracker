# syntax=docker/dockerfile:1
FROM ruby:3.3.6

WORKDIR /app

ENV RAILS_ENV=docker_test

# Синхронизируем Bundler с версией из Gemfile.lock
ARG BUNDLER_VERSION=2.6.7
RUN gem install bundler -v "$BUNDLER_VERSION"

# Устанавливаем зависимости отдельно, чтобы использовать кэш слоев
COPY Gemfile Gemfile.lock ./
RUN bundle _${BUNDLER_VERSION}_ install

# Копируем код
COPY . .

# Запуск линтера по умолчанию
CMD ["bundle", "exec", "rubocop", "-c", ".rubocop.yml"]
