FROM ruby:3.2.2
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN npm install yarn -g -y
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD package.json yarn.lock /myapp/
RUN yarn install
ADD . /myapp
