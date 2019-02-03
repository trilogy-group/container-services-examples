# Development with Devspaces

### Devspaces 

Manage your Devspaces https://www.devspaces.io/.

Read up-to-date documentation about cli installation and operation in https://www.devspaces.io/devspaces/help.

Here follows the main commands used in Devspaces cli. 

|action   |Description                                                                                   |
|---------|----------------------------------------------------------------------------------------------|
|`devspaces --help`                    |Check the available command names.                               |
|`devspaces create [options]`          |Creates a DevSpace using your local DevSpaces configuration file |
|`devspaces start <devSpace>`          |Starts the DevSpace named \[devSpace\]                           |
|`devspaces bind <devSpace>`           |Syncs the DevSpace with the current directory                    |
|`devspaces info <devSpace> [options]` |Displays configuration info about the DevSpace.                  |

Use `devspaces --help` to know about updated commands.

#### Before you begin

This example repo uses git submodules. After regular clone make sure that all submodules are cloned by typing in cloned repo directory:

```bash
git submodule update --init
```

#### Development flow

You should have Devspaces cli services started and logged to develop with Devspaces.

Use this directory `spina_devspaces` as starting point for following commands.

1 - Create Devspaces

```bash
cd devspaces/docker
devspaces create
cd ../../spina_sample_app/

```

2 - Start containers

```bash
devspaces start spina
```

3 - Start container synchronization

```bash
devspaces bind spina
```

4 - Grab some container info

```bash
devspaces info spina
```

Retrieve published DNS and endpoints using this command

5 - Connect to development container

```bash
devspaces exec spina
```

6 - Configure Spina Development environment

Once synch ends you can copy default configuration files into development folder and configure the build.

```bash
cp /opt/devspaces/configs/rails/*.* config/
bundle install
bundle exec rake assets:precompile
bundle exec rake db:load_sample_if_empty_db
```

7 - Run Spina

```bash
bundle exec puma
```

Access application URLs:

Using information retrieved in step 4, access the following URL's:

* Application (bound to port 3000):
  * `http://spina.<devspaces-user>.devspaces.io:<published-ports>/admin`

Use the following credentials:

* email: spina@engineyard.com
* password: engineyard

### Docker Script Manager (CLI)

Currently, we have these command available to work using local docker compose.

```bash
devspaces/docker-cli.sh <command>
```

|action    |Description                                                               |
|----------|--------------------------------------------------------------------------|
|`build`   |Builds images                                                             |
|`deploy`  |Deploy Docker compose containers                                          |
|`undeploy`|Undeploy Docker compose containers                                        |
|`start`   |Starts Docker compose containers                                          |
|`stop`    |Stops Docker compose containers                                           |
|`exec`    |Get into the container                                                    |

Use this directory `spina_devspaces` as starting point for following commands.

#### CLI Development flow

1 - Build and Run `docker-compose` locally.

```bash
devspaces/docker-cli.sh build
devspaces/docker-cli.sh deploy
devspaces/docker-cli.sh start
```

2 - Get into container

```bash
devspaces/docker-cli.sh exec
```

3 - Configure Spina Development environment

You can copy default configuration files into development folder and configure the build.

```bash
cp /opt/devspaces/configs/rails/*.* config/
bundle install
bundle exec rake assets:precompile
bundle exec rake db:load_sample_if_empty_db
```

4 - Run Spina

```bash
bundle exec puma
```

Access application URLs:

* Application (bound to port 3000):
  * http://localhost:3000/admin

Use the following credentials:

* email: spina@engineyard.com
* password: engineyard

### Entrypoint Actions

    1 - Postgres SQL is started up in background
