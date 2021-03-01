FROM ruby:2.5.7
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /yaraneba
WORKDIR /yaraneba
ADD ./yaraneba /yaraneba
RUN bundle install
