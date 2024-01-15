FROM ruby:3.2.2 as rails-toolbox

ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH

RUN gem install rails bundler

WORKDIR $INSTALL_PATH

COPY . .

RUN bundle install

# Run the rails server
CMD ["rails", "server"]
