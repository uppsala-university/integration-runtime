class karaf {

	$version = "4.0.4"

	# Packages Karaf depends upon.
	# But this is not declared in the Karaf rpm
	# since there is no good "java" dependency.... openjdk, oracle jdk, ibm jdk etc..
	package { "java-1.7.0-openjdk":
  	ensure		=> present
  }

  file { '/opt/rpm':
  	ensure		=> directory
  }

  file { "/opt/rpm/apache-karaf-$version-0.x86_64.rpm":
  	source 		=> "puppet:///modules/karaf/apache-karaf-$version-0.x86_64.rpm",
  	require		=> File['/opt/rpm']
  }

	package { 'apache-karaf':
		require 	=> File["/opt/rpm/apache-karaf-$version-0.x86_64.rpm"],
		provider 	=> 'rpm',
		source 		=> "/opt/rpm/apache-karaf-$version-0.x86_64.rpm"
	}

	service { 'apache-karaf':
		enable		=> true,
		ensure 		=> running,
		require		=> [Package['java-1.7.0-openjdk'],
		Package['apache-karaf']]
	}

}
