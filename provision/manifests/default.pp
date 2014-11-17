node "centos.dev.uu.se" {
	include devtools
	include without-iptables
	include servicemix
	include ladok-dummy-webserver
	#include mariadb
	#include neo4j
	
	servicemix::smx-relink { 'deploy' :
		src		=> '/opt/servicemix/apache-servicemix-5.1.2/deploy',
		dest	=> '/vagrant/smx/deploy'
	}
	
}

node "centos.prod.uu.se" {
	include devtools
	include servicemix
	include ladok-dummy-webserver
	#include mariadb
	#include neo4j
}
