# A simple EY Container Service

This example deploys a very simple Container Service which does not depend on other components.

1. Create a Container Service Definition with the following parameters:
  1. Two volumes testvol1 and testvol2, mounted on /vol1 and /vol2.
  2. Image Repository: jfuechsl/simplesvc
  3. Exposed Ports: 5000
2. Deploy the Container Service with the following parameters:
  1. Configure load balancing for the service
  2. Use the latest image tag
  3. CPU: 512, Memory: 1024
  4. Environment variable: EY_hello=world
3. Access the service through the App Load Balancer endpoint and:
  1. Verify that the /vol1 and /vol2 mounts are shown
  2. Verify that the EY_hello environment variable is shown
  3. Treat yourself to the latest xkcd comic.
