# Spina as an EY Container Service

## Introduction

[Spina](https://www.spinacms.com/) is a Rails-based CMS which we adapted to an example app for EY Cloud at [github.com/engineyard/spina_sample_app](https://github.com/engineyard/spina_sample_app).

This example takes the Engine Yard Spina example app and transforms it
to a dockerized Engine Yard Container Service with a RDS database.

It also includes a local setup which helps in development and testing.

## Local Setup

You need a recent version of Docker and Docker Compose installed to be able to run this example.

The `docker-compose.local.yml` file describes the local setup. You can start through the following steps:
1. Start the database service: `docker-compose -f docker-compose.local.yml up -d database`
2. Initialize the database: `docker-compose -f docker-compose.local.yml run --rm web bundle exec rake db:load_sample_if_empty_db`
3. Start the rails web app: `docker-compose -f docker-compose.local.yml up -d web`
4. View the logs: `docker-compose -f docker-compose.local.yml logs -f`
5. Open the browser and go to [http://localhost:3000/](http://localhost:3000/)
6. Clean up: `docker-compose -f docker-compose.local.yml down`

## Deployment on Engine Yard

To deploy the app as a Container Service on Engine Yard Cloud, you need to go through the following process.

1. Create a RDS service (us-east-1, vpc-01a2811ecfe92baa4, postgres 9.6.x, db.t2.small, 10GB standard)
2. Create a Docker Repository
3. Configure access to RDS instance
  1. In AWS console, locate the RDS instance.
  2. Open the security group of the instance and edit it.
  3. Add ingress rule to allow tcp on port 5432 from your deployment site.
4. Create a file `.env` at the deployment site from the `.env.example` file.
5. Init the DB: `docker-compose -f docker-compose.dbinit.yml run --rm dbinit`
6. Remove the RDS instance access rule created in step 3.
7. Build the Docker Image: `docker-compose -f docker-compose.deploy.yml build`
8. Authenticate against the Docker Registry.
9. Push the Docker Image: `docker-compose -f docker-compose.deploy.yml push`
10. Create an App Load Balancer with a HTTP listener and a default target group.
11. Create a Container Service Definition (screenshot)
12. Deploy a Container Service
  1.  Supply the environment variables with values from the `.env` file.
  2.  See screenshot
13. Configure access to RDS instance from the security group of the container service
  1.  See step 3 for details.
14. Verify the container service works correctly by accessing the service through the ALB endpoint.
15. Load test, e.g. `wrk -c 12 -d 180 -t 4 http://jffargatespina2-970170598.us-east-1.elb.amazonaws.com/files/railties/RDOC_MAIN_rdoc.html`
