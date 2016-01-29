node "centos.dev.uu.se" {
	include without-iptables
	include java
	include karaf
	include activemq
	include ladok-dummy-webserver
	include mariadb
	include directorystructure

	# Deprecated no longer used modules
	#include devtools
	#include servicemix
	#include neo4j

	mariadb::passwd{"root":
		pwd => 'magento'
	} ->

	mariadb::database{'logdb':
		ensure   => 'importdb',
		sql      => '/vagrant/provision/modules/mariadb/sql/init.sql',
		adminPwd => 'magento'
	} ->

	mariadb::user{'idintegration':
		password => 'foobar',
		database => 'logdb',
		adminPwd => 'magento'
	}

}

node "centos.prod.uu.se" {
	#include devtools
	include servicemix
	#include ladok-dummy-webserver
	include mariadb
	#include neo4j
}
