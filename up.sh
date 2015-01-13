#!/bin/sh

vagrant up

mvn3 clean package -Dmaven.test.skip=true
( cd ../ladok3; mvn3 clean package -Dmaven.test.skip=true )

# echo "Note! use password 'vagrant' when using scp to vagrant vm:"
# scp -P 2222 \
#    ../ladok3/ladok3atom-*/target/*.jar \
#    */target/*.jar \
#    vagrant@localhost:/opt/servicemix/apache-servicemix-5.1.2/deploy/

cp -v \
    ../ladok3/ladok3atom-*/target/*.jar \
    */target/*.jar \
    smx/deploy/

echo "You might now be interested in doing:"
echo "vagrant ssh"
echo "tail -f /var/lib/servicemix/log/servicemix.log"
echo "sudo service apache-servicemix stop|start"
