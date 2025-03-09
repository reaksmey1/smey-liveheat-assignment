# Use the official Ruby image from the Docker registry
FROM ruby:3.1

# Install dependencies for Rails and SQLite3
RUN apt-get update -qq && apt-get install -y nodejs sqlite3 libsqlite3-dev

# Set the working directory inside the container
WORKDIR /smey-assignment

# Install Bundler
RUN gem install bundler

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install the required gems
RUN bundle install

# Copy the rest of the application files
COPY . .

# Set environment variables
ENV RAILS_ENV=development
ENV RACK_ENV=development

# Ensure the database is created, migrated, and seeded
RUN bundle exec rake db:create
RUN bundle exec rake db:migrate
RUN bundle exec rake db:seed

# Expose the port Rails will run on
EXPOSE 3000

# Set the default command to run the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]