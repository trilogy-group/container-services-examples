# Sidekiq Workers as a Container Service

## Introduction

This example shows how EY Cloud Container Services can be used to deploy Sidekiq
workers for an EY Cloud Application Deployment.

It also includes a local setup which helps in development and testing.

## Local Setup

You need a recent version of Docker and Docker Compose installed to be able to run this example.

The `docker-compose.local.yml` file describes the local setup. You can start through the following steps:
1. Create a file `.env` from the `.env.example` file.
2. Start the database service: `docker-compose -f docker-compose.local.yml up -d database`
3. Start the redis service: `docker-compose -f docker-compose.local.yml up -d redis`
4. Initialize the database: `docker-compose -f docker-compose.local.yml run --rm web bundle exec rake db:migrate`
5. Start the Rails web app: `docker-compose -f docker-compose.local.yml up -d web`
6. Start the Sidekiq worker: `docker-compose -f docker-compose.local.yml up -d worker`
7. Schedule jobs: `docker-compose -f docker-compose.local.yml run --rm -e ECHO_JOB_COUNT=100 web bundle exec rake echo:generate`
8. View the logs: `docker-compose -f docker-compose.local.yml logs -f`
9. Open the browser and go to the Sidekiq dashboard at [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq)
10. Clean up: `docker-compose -f docker-compose.local.yml down`

## Deployment on Engine Yard

To deploy the app as a Container Service on Engine Yard Cloud, you need to go through the following process.

1. Create a new application
  1. Rails 5
  2. Repository: https://github.com/engineyard/rails_activejob_example.git
2. Create a new environment for the application
  1. Boot it with a utility instance named "redis"
  2. Upload the custom cookbooks recipes inside [rails_activejob_example](./rails_activejob_example)
  3. Deploy the `no-sidekiq-workers` branch of the application.
3. Create a Docker Repository for the worker Docker Image
4. Build the Docker Image: `docker-compose -f docker-compose.deploy.yml build`
5. Authenticate against the Docker Registry.
6. Push the Docker Image: `docker-compose -f docker-compose.deploy.yml push`
7. Create a Container Service Definition
8. Deploy a Container Service
  1. Define the following environment variables with correct values:
      ```
      DB_HOST
      DB_PORT=5432
      DB_NAME
      DB_USER
      DB_PASSWORD
      SECRET_KEY_BASE
      REDIS_HOST
      REDIS_PORT=6379
      ```
9.  Update the environment security group to allow ingress from the security group of the Container Service.
10. Create some jobs from the application instance: `ECHO_JOB_COUNT=100 bundle exec rake echo:generate`
11. Open the application URL in the browser and navigate to `/sidekiq`.
12. Monitor the Sidekiq dashboard to verify the jobs are processed.
