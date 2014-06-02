class servicemix {

	# Packages servicemix depends upon.
	# But this is not declared in the servicemix rpm
	# since there is no good "java" dependency.... openjdk, oracle jdk, ibm jdk etc.. 
	package { "java-1.7.0-openjdk":
    	ensure		=> present
   	}

   	file { '/opt/rpm':
   		ensure	=> directory
   	}

   	file { '/opt/rpm/apache-servicemix-4.5.3-0.noarch.rpm':
   		source 		=> 'puppet:///modules/servicemix/apache-servicemix-4.5.3-0.noarch.rpm',
   		require		=> File['/opt/rpm']
   	}

	package { 'apache-servicemix':
		require 	=> File['/opt/rpm/apache-servicemix-4.5.3-0.noarch.rpm'],
		provider 	=> 'rpm',
		source 		=> '/opt/rpm/apache-servicemix-4.5.3-0.noarch.rpm'
	}

	service { 'apache-servicemix':
		enable		=>	true,
		ensure 		=> running,
		require		=> Package['apache-servicemix']
	}

	file { '/opt/servicemix/apache-servicemix-4.5.3/deploy/abdera-1.1.3-feature.xml':
   		source 		=> 'puppet:///modules/servicemix/abdera-1.1.3-feature.xml',
   		require		=> Service['apache-servicemix']

   	}
	
	file { '/opt/servicemix/smx-relink.sh': 
		source 		=> 'puppet:///modules/servicemix/smx-relink.sh',
		mode		=> 0755,
		owner		=> root,
		require		=> Package['apache-servicemix'],
	}

}
