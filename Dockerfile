FROM ruby:2.4.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /clubloot
WORKDIR /clubloot
ADD Gemfile /clubloot/Gemfile
ADD Gemfile.lock /clubloot/Gemfile.lock
RUN bundle install
ADD . /clubloot
