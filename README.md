TaskManager
===

## System Requirements

- Ruby 3.3.0
- Rails 8.0.2
- PostgreSQL 16
- Docker (optional)
- Docker Compose (optional)

## Installation

```bash
# Clone the repository
git clone https://github.com/vinhintw/todo-list-app-rails.git

cd todo-list-app-rails
# Install dependencies
bundle install
# Set up the database
rails db:create
rails db:migrate
# Seed the database (optional)
rails db:seed
```
## Running the Application

```bash
# Start the Rails server
rails server
```

## Testing

To run the test suite, you can use RSpec. Make sure you have the necessary gems installed:

```bash
bundle exec rspec
```

## Check Ruby Syntax

You can check the Ruby syntax and style using RuboCop:

```bash
bundle exec rubocop
```

## Docker Setup (Optional)

If you prefer to run the application using Docker, follow these steps:

1. Create a `.env` file in the root of the project and configure your environment variables.

```bash
# Copy the example file
cp .env.example .env.production.local
```

2. Run scripts to build and run the Docker containers:

```bash
./scripts/build-production.sh
```

open your browser and navigate to `http://localhost:3000` to access the application.

3. To clean up Docker containers and images, you can run:

```bash
./scripts/cleanup.sh
```

  