class karaf {

	$version = "4.0.4"
#	$java_version = "1.7.0"

	# Packages Karaf depends upon.
	# But this is not declared in the Karaf rpm
	# since there is no good "java" dependency.... openjdk, oracle jdk, ibm jdk etc..
#	package { "java-$java_version-openjdk":
# 		ensure		=> present
# 	}

#	file { '/opt/rpm':
# 		ensure		=> directory
# 	}

	file { "/opt/rpm/apache-karaf-$version-0.x86_64.rpm":
 		source 		=> "puppet:///modules/karaf/apache-karaf-$version-0.x86_64.rpm",
# 		require		=> File['/opt/rpm']
		require		=> Class['directorystructure']
	}

	package { 'apache-karaf':
		require 	=> File["/opt/rpm/apache-karaf-$version-0.x86_64.rpm"],
		provider 	=> 'rpm',
		source 		=> "/opt/rpm/apache-karaf-$version-0.x86_64.rpm"
	}

	service { 'apache-karaf':
		enable		=> true,
		ensure 		=> running,
		require		=> [Class['java'], Package['apache-karaf']]
	}

}
