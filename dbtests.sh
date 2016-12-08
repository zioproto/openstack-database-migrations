#!/bin/bash
set -x

#TODO write a nice script that checks return codes

keystone-manage db_version
keystone-manage db_sync
keystone-manage db_version

glance-manage db_version
glance-manage db_sync
glance-manage db_version

nova-manage db version
nova-manage db sync
nova-manage db version

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
