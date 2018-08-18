#!/bin/bash

# il faut démarre zookeeper avant
bash -c "zookeeper-server start"
# On start kafka
bash -c "/usr/hdp/2.6.2.0-205/kafka/bin/kafka start /usr/hdp/2.6.2.0-205/kafka/config/server.properties"

#/usr/hdp/2.6.2.0-205/kafka/bin/kafka start

tail -f /dev/null