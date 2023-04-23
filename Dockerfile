FROM ruby:3.2.2 AS development
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

FROM ruby:3.2.2 AS production
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN npm install yarn -g -y
RUN mkdir /myapp
WORKDIR /myapp
COPY --from=development /myapp/Gemfile /myapp/Gemfile
COPY --from=development /myapp/Gemfile.lock /myapp/Gemfile.lock
RUN bundle install --without development test --deployment
COPY --from=development /myapp/package.json /myapp/yarn.lock /myapp/
COPY --from=development /myapp/node_modules /myapp/node_modules
COPY --from=development /myapp/public /myapp/public
COPY --from=development /myapp /myapp
ENV RAILS_ENV=production
RUN bundle exec rake db:create
RUN bundle exec rake db:migrate
RUN bundle exec rake assets:precompile
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
