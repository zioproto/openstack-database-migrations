#!/bin/bash
set -x

#TODO write a nice script that checks return codes

keystone-manage db_version
keystone-manage db_sync
keystone-manage db_version

glance-manage db_version
glance-manage db_sync
glance-manage db_version

#Make sure you have run this command in Mitaka
# before going on all Mitaka online migrations should be completed
#nova-manage db online_data_migrations

# Commands for Nova to be run in Newton
nova-manage db version
nova-manage api_db version
nova-manage db sync
nova-manage api_db sync
nova-manage db version
nova-manage api_db version
nova-manage db online_data_migrations

neutron-db-manage current
neutron-db-manage upgrade --expand
neutron-db-manage upgrade --contract
neutron-db-manage upgrade heads
neutron-db-manage current

cinder-manage db version
cinder-manage db sync
cinder-manage db version

heat-manage db_version
heat-manage db_sync
