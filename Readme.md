# Test Openstack database migrations

Upgrading Openstack you will need to make database migrations. This step often fails, so operators recommend to test the migrations against a backup of the production database.

# Create a empty database

Run a mysql database:

     docker run --network=host  --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql:5.6 --character-set-server=utf8 --collation-server=utf8_unicode_ci


It is important that character set and collation are exactly the same as your production mysql.

# Run the tool

     docker run --network=host -v ~/backups/:/backups/ -ti zioproto/openstack-db-migrations-check:ocata /bin/bash


The `Dockerfile` is included in this git repository. You probably want to adapt it at the upgrade you want to do. I wrote this file for my liberty to mitaka upgrade.

You can build like this:

    docker build -t openstack-db-migrations-check .


Check db connectivity:

    mysql -u root -pmy-secret-pw -h 127.0.0.1


Load the backups you need:


    mysql -u root -pmy-secret-pw -h 127.0.0.1 < /backups/somefile.sql


Now in the file `/dbtests.sh` you find the command to give to check the migrations. All the Openstack components should be already correctly configured to talk with your fresh database on localhost.
