# Project Setup Guide

## 1. Prerequisites

- **Ruby version:** 3.1.3
  (Defined in `.ruby-version` and Dockerfile. Use rbenv, rvm, or as provided by Docker.)
- **Bundler:** Install with `gem install bundler` if not present.
- **Docker & Docker Compose:** Required for local development and service orchestration.
- **macOS or Unix-like OS:** (You are on macOS.)

## 2. System Dependencies

- **PostgreSQL 16:** Provided via Docker (`postgres:16` image).
- **Redis 7:** Provided via Docker (`redis:7` image).
- **Node.js & Yarn:** Only needed if you want to run asset compilation locally (otherwise handled in Docker).
- **libvips, libjemalloc2, postgresql-client:** Installed in the Docker image for image processing and database access.

## 3. Project Setup

1. **Clone the repository** and enter the project directory.
2. **Credentials:**
   - Ensure `config/master.key` exists (copy from `config/master.key.example` if needed).
   - Make sure `config/credentials/development.yml.enc` and `config/credentials/development.key` exist for development credentials.
3. **Configuration files:**
   - Database configuration is handled by `config/database.yml` and environment variables in `docker-compose.yml`.

## 4. Installing Dependencies

- **With Docker (recommended):**
  All dependencies are installed automatically during `docker-compose build`.
- **Locally (not recommended):**
  Run `bundle install` to install Ruby gems.

## 5. Environment Variables

- Set in `docker-compose.yml` for local development:
  - `POSTGRES_USER=postgres`
  - `POSTGRES_PASSWORD=password`
  - `POSTGRES_DB=web_scraper_development`
- For production, set `RAILS_MASTER_KEY` (value from `config/master.key`).

## 6. Running the Application

- Start all services (web, db, redis, sidekiq) with:
  ```
  docker-compose up
  ```
- The Rails server will be available at [http://localhost:3000](http://localhost:3000).

## 7. Database Setup

- To create and migrate the database, run:
  ```
  docker-compose run web rails db:create db:migrate
  ```

## 8. Running Background Jobs

- **Sidekiq** is included and started via Docker Compose. No extra steps are needed.

## 9. Useful Commands

- **Rails console:**
  `docker-compose run web rails console`
- **Run tests:**
  (No test framework is specified in the Gemfile. If you add RSpec or Minitest, use the appropriate command, e.g., `docker-compose run web bundle exec rspec`.)
- **Precompile assets:**
  `docker-compose run web rails assets:precompile`
- **Static analysis:**
  - Security: `bin/brakeman`
  - Linting: `bin/rubocop`

## 10. File Structure

- Application code: `app/`
- Configuration: `config/`
- Database seeds: `db/seeds.rb`
- Docker configuration: `Dockerfile`, `docker-compose.yml`
- Setup script: `bin/setup` (installs dependencies, prepares DB, clears logs)

## 11. Notes

- The Dockerfile is optimized for production but works for development with Docker Compose.
- Assets are precompiled during the Docker build.
- For production, set `RAILS_ENV=production` and provide the correct `RAILS_MASTER_KEY`.
- To update dependencies or reset the environment, use `bin/setup`.

---

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...
