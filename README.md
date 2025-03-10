# Smey Assignment - School Race Day

## Project Overview

This is a web application for managing and tracking race day events for a school race. It allows the creation of races, assignment of students to lanes, and management of rankings.

## Requirements

- **Ruby version**: 3.1.2p20
- **Rails version**: 7.2.2.1

## Setup

### If you're **not using Docker**

1. **Install the required Ruby gems:**

   ```bash
   bundle install
   ```

2. **Set up the database:**

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. **Start the Rails server:**

    ```bash
   rails s
   ```

   The application will be available at: http://localhost:3000/

### If you're using Docker**

1. **Build and start the application using Docker Compose:**

    ```bash
    docker-compose up --build
    ```

    This will build the Docker images and start the application. The application will be available at: http://localhost:3000/

### Running test

    bundle exec rspec
