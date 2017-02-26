FROM ruby:2.2.5

RUN gem install bundle

ENV APP_HOME /srv/guestbook
WORKDIR $APP_HOME

ADD . $APP_HOME

RUN bundle install


 