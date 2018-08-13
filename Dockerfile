FROM ubuntu:16.04
RUN apt-get update
RUN apt-get -y install ubuntu-cloud-keyring software-properties-common
RUN set -x \
    && add-apt-repository cloud-archive:newton \
    && apt-get -y update \
    && apt-get -y install \
       python-mysqldb \
       keystone \
       glance \
       nova-api \
       cinder-api \
       neutron-server \
       python-neutron-lbaas \
       neutron-l2gateway-agent \
       heat-api \
       mysql-client \
    && apt-get -y clean

# Set db in keystone.conf
RUN sed -i -e "s/connection = sqlite:\/\/\/\/var\/lib\/keystone\/keystone.db/connection = mysql:\/\/root:my-secret-pw@127.0.0.1\/keystone/" "/etc/keystone/keystone.conf"

# Set db in glance.conf
RUN sed -i -e "s/#connection = <None>/connection = mysql:\/\/root:my-secret-pw@127.0.0.1\/glance/" "/etc/glance/glance-api.conf"

#Set db in nova.conf
RUN echo "[database] \n\
connection = mysql://root:my-secret-pw@127.0.0.1/nova" >> /etc/nova/nova.conf
RUN echo "[api_database] \n\
connection = mysql://root:my-secret-pw@127.0.0.1/nova_api" >> /etc/nova/nova.conf

#Set db in cinder.conf
RUN echo "[database] \n\
connection = mysql://root:my-secret-pw@127.0.0.1/cinder" >> /etc/cinder/cinder.conf

#Set db in neutron.conf
RUN sed -i -e "s/connection = sqlite:\/\/\/\/var\/lib\/neutron\/neutron.sqlite/connection = mysql:\/\/root:my-secret-pw@127.0.0.1\/neutron/" "/etc/neutron/neutron.conf"

#Set db in heat.conf
RUN sed -i -e "s/#connection = <None>/connection = mysql:\/\/root:my-secret-pw@127.0.0.1\/heat/" "/etc/heat/heat.conf"

COPY dbtests.sh /dbtests.sh
RUN chown root.root /dbtests.sh  && chmod a+x /dbtests.sh

#COPY bootstrap.sh /etc/bootstrap.sh
#RUN chown root.root /etc/bootstrap.sh && chmod a+x /etc/bootstrap.sh
#ENTRYPOINT ["/etc/bootstrap.sh"]
