FROM ruby:3.2.0-alpine AS build
WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN gem install bundler:2.3.5
RUN bundle config set --local path "vendor/bundle" && \
  bundle install --jobs 4 --retry 3

COPY . /app/
FROM ruby:3.2.0-alpine
WORKDIR /app
RUN bundle config set --local path "vendor/bundle"
RUN mkdir log
RUN touch log/production.log

COPY --from=build /app /app/
CMD ["ruby", "main.rb"]
