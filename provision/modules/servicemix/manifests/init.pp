class servicemix {

	$version = "5.4.0"

	# Packages servicemix depends upon.
	# But this is not declared in the servicemix rpm
	# since there is no good "java" dependency.... openjdk, oracle jdk, ibm jdk etc..
	package { "java-1.7.0-openjdk":
  	ensure		=> present
  }

  file { '/opt/rpm':
  	ensure		=> directory
  }

  file { "/opt/rpm/apache-servicemix-$version-0.noarch.rpm":
  	source 		=> "puppet:///modules/servicemix/apache-servicemix-$version-0.noarch.rpm",
  	require		=> File['/opt/rpm']
  }

	package { 'apache-servicemix':
		require 	=> File["/opt/rpm/apache-servicemix-$version-0.noarch.rpm"],
		provider 	=> 'rpm',
		source 		=> "/opt/rpm/apache-servicemix-$version-0.noarch.rpm"
	}

	file { "/opt/servicemix/apache-servicemix-$version/deploy/uu-features.xml":
  	source 		=> 'puppet:///modules/servicemix/uu-features.xml',
  	require		=> Service['apache-servicemix'],
		owner			=> smx,
		group			=> smx
  }

	file { '/opt/servicemix/smx-relink.sh':
		source 		=> 'puppet:///modules/servicemix/smx-relink.sh',
		mode			=> 0755,
		owner			=> root,
		require		=> Package['apache-servicemix'],
	}

  file { '/opt/servicemix/.m2':
  	ensure		=> directory,
		owner			=> smx,
		require		=> Package['apache-servicemix']
  }

#	file { "/opt/servicemix/apache-servicemix-$version/etc/org.apache.activemq.server-dlq.cfg":
#		source 		=> 'puppet:///modules/servicemix/org.apache.activemq.server-dlq.cfg',
#		require		=> Package['apache-servicemix']
#	}

	file { "/opt/servicemix/apache-servicemix-$version/etc/org.apache.activemq.server-default.cfg":
		source 		=> 'puppet:///modules/servicemix/org.apache.activemq.server-default.cfg',
		require		=> Package['apache-servicemix']
	}

	file { "/opt/servicemix/apache-servicemix-$version/etc/org.apache.activemq.server-dlq.cfg":
		source 		=> 'puppet:///modules/servicemix/org.apache.activemq.server-dlq.cfg',
		require		=> Package['apache-servicemix']
	}

#	file { "/opt/servicemix/apache-servicemix-$version/etc/ladok-atom-adapter.cfg":
#		source 		=> 'puppet:///modules/servicemix/ladok-atom-adapter.cfg',
#		require		=> Package['apache-servicemix']
#	}

	file { "/opt/servicemix/apache-servicemix-$version/etc/activemq.xml":
		source 		=> 'puppet:///modules/servicemix/activemq.xml',
		require		=> Package['apache-servicemix']
	}

	service { 'apache-servicemix':
		enable		=> true,
		ensure 		=> running,
		require		=> [Package['java-1.7.0-openjdk'],
									Package['apache-servicemix'],
									File["/opt/servicemix/apache-servicemix-$version/etc/org.apache.activemq.server-default.cfg"],
									File["/opt/servicemix/apache-servicemix-$version/etc/org.apache.activemq.server-dlq.cfg"],
#									File["/opt/servicemix/apache-servicemix-$version/etc/ladok-atom-adapter.cfg"],
									File["/opt/servicemix/apache-servicemix-$version/etc/activemq.xml"]]
	}

}
