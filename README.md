# Omeka Project Mapping Womens Suffrage

This repository holds the project files for the map.mappingwomenssuffrage.org.uk omeka system.

## Run in Codespaces

1. Create a codespace on the `main` branch
2. Upload a copy of the database as a mysqldump sql file to `/db/`
3. Copy `docker-compose-variables.env.template` to `docker-compose-variables.env`. It's recommended to leave these values but if there is a need to access any repository hosted on a private gitlab instance, a [GitLab deploy key](https://docs.gitlab.com/ee/user/project/deploy_keys/) must be generated.
4. Run scripts.sh, which will need to be made executable using `chmod +x scripts.sh` followed by `./scripts.sh`. This will download the latest version of a series of scripts under a `scripts folder`. These are automation scripts used to build the application on Codespaces.
5. Install the Docker extension in this codespace.
6. Run `docker-compose up` (or right-click on `docker-compose.yml` and select the appropriate option).


## Local Development

0. We assume you have docker-compose, docker and composer installed in WSL2. There are scripts available for this [here](https://actechlab.warwick.ac.uk/digital-humanities/wsl-dev-environment).

1. Edit the config/project-configuration.yml file to set your environment. The different environment configurations are outlined in [this document](https://livewarwickac.sharepoint.com/:x:/r/sites/TEAMDigitalHumanities/Shared%20Documents/Service%20Improvement%20Projects/Omeka%20S%20Service/Omeka%20S%20Data%20and%20Environments.xlsx?d=w799d795897b84e8087018fe14d998801&csf=1&web=1&e=MQugGc).
2. Ensure that any data you need to load into the database is in a single .sql file and is located at db/omeka.sql. The database container will import these files when built. Import errors may not be shown in the Docker output so please do make sure the data is correct.
3. Modify the composer.json file to specify the plugins, theme and Omeka version used in your project. Ensure that packages are defined, version and location of the file should be included. A common issue is for the installer-name to not match the name of the <class>Plugin.php which means it will not be detected as a valid plugin. Where there are multiple versions of the same package, it's important that the versions are in reverse order (highest at the top). The below shows the entries for the Ldap plugin:

```json
        {
            "type": "package",
            "package": {
                "name": "bgsu-lits/ldap",
                "version": "0.4.0",
                "type": "omeka-plugin",
                "source": {
                    "url": "https://github.com/BGSU-LITS/LDAP-Plugin.git",
                    "type": "git",
                    "reference": "0.4.0"
                },
                "extra": {
                    "installer-name": "Ldap"
                }
            }
            
        },
```

4. In the composer file, ensure your dependencies are required in the require section of the JSON file as shown in the example below. The Omeka S version should also be included.

```json
    "require": {
        "omeka/omeka": "3.1.1",
        "bgsu-lits/ldap": "0.4.0"
    }
```

5. There is now enough specification that you can build the docker local install. To start the local development run the build-and-deploy.sh script with the variable "test".

```bash
chmod +x scripts/build-and-deploy.sh
scripts/build-and-deploy.sh -b test
```

At the moment, only the test environment is implemented.

This script will do the following:

* create the omeka S filesystem in /build/html
* create the environment configuration files (currently build/html/.htaccess, build/html/config/database.ini, build/html/config/local.config.php)
* starts docker compose
* imports the database dump in db/omeka.sql into the database

**Note** Please wait until the database has imported all the data and shows that 'mysqld: ready for connects.' like the below.

```sh
db_1         | 2022-11-30T16:19:54.491377Z 0 [Warning] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
db_1         | 2022-11-30T16:19:54.503270Z 0 [Note] Event Scheduler: Loaded 0 events
db_1         | 2022-11-30T16:19:54.505373Z 0 [Note] mysqld: ready for connections.
db_1         | Version: '5.7.40'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
```

If you try to connect before the database is initialised then the install script starts (despite data loading into the database for our install). You will hit an error and be unable to use Omeka S. If this happens then run docker-compose down and rerun the build-and-deploy.sh script.

### Accessing Omeka

* You can access the omeka web interface by going to http://127.0.0.1
* The phpmyadmin interface is accessed via http://127.0.0.1:8080. To log in use the database credentials mentioned below.

The credentials for the test environment are below.

### Test environment variables

If you set the environment to "test" via the argument to the build-and-deploy.sh script then the following variables are set.

database username: test
database password: test
database: db1
database host: db

## Development notes

*Note:* Clone this repo into a directory within the WSL partition (such as /home/james) and not in Windows (/mnt/c/...). The composer install will be slow or completely file due to permissions issues if run in a mounted filesystem.
