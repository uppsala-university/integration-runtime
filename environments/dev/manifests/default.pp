node "centos.dev.uu.se" {
	include withoutiptables
	include java
	include karaf
	include yumrepo
	include activemq
	include ladokdummywebserver
	include mariadb

	mariadb::passwd{"root":
		pwd => 'magento'
	} ->

	mariadb::database{'logdb':
		ensure   => 'importdb',
		sql      => '/vagrant/environments/modules/mariadb/sql/init.sql',
		adminPwd => 'magento'
	} ->

	mariadb::user{'idintegration':
		password => 'foobar',
		database => 'logdb',
		adminPwd => 'magento'
	}

}

node "centos.prod.uu.se" {
	include servicemix
	include mariadb
}
