FROM ruby:2.5.7
RUN apt update -qq && apt install -y build-essential libpq-dev nodejs
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list && \
apt update && \
apt install -y google-chrome-stable
RUN mkdir /yaraneba
WORKDIR /yaraneba
ADD ./yaraneba /yaraneba
RUN bundle install
