node "centos.dev.uu.se" {
	include devtools
	include without-iptables
	include servicemix
	include ladok-dummy-webserver
	include mariadb
	#include neo4j
	
	servicemix::smx-relink { 'deploy' :
		src		=> '/opt/servicemix/apache-servicemix-5.4.0/deploy',
		dest	=> '/vagrant/smx/deploy'
	}

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
	include devtools
	include servicemix
	include ladok-dummy-webserver
	#include mariadb
	#include neo4j
}
