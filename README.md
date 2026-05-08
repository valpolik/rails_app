# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

---

Ruby 4.0.3 and Rails 8.1.3 application with REST JSON API for user-resources, with authentication & authorization

- Requires Docker or Ruby 4.0.3 && PostgreSQL 17.9
- docker compose --file docker-compose-new.yml up --build --remove-orphans
- docker compose --file docker-compose-new.yml exec web rails console
- Use "lib/users_api_client.rb" for use API from "app/controllers/users_controller.rb" as REST Client
