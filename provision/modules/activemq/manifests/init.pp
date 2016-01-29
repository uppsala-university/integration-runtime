class activemq {

	$version = "5.13.0"

	# Packages ActiveMQ depends upon.
	# But this is not declared in the Karaf rpm
	# since there is no good "java" dependency.... openjdk, oracle jdk, ibm jdk etc..
#	package { "java-1.7.0-openjdk":
#  	ensure		=> present
# }

#  file { '/opt/rpm':
#  	ensure		=> directory
#  }

  file { "/opt/rpm/apache-activemq-$version-0.noarch.rpm":
  	source 		=> "puppet:///modules/activemq/apache-activemq-$version-0.noarch.rpm",
#  	require		=> File['/opt/rpm']
  	require		=> Class['directorystructure']
  }

	package { 'apache-activemq':
		require 	=> File["/opt/rpm/apache-activemq-$version-0.noarch.rpm"],
		provider 	=> 'rpm',
		source 		=> "/opt/rpm/apache-activemq-$version-0.noarch.rpm"
	}

	service { 'apache-activemq':
		enable		=> true,
		ensure 		=> running,
		require		=> [Class['java'], Package['apache-activemq']]
#		require		=> [Package['java-1.7.0-openjdk'],
	}

}
