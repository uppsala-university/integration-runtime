class neo4j {

	# MariaDB is not in default repository. Install.
	#
	yumrepo { "neo4j":
		baseurl 	=> "http://yum.neo4j.org",
		descr		=> "Neo4j Yum Repo",
		enabled 	=> 1,
		gpgkey 		=> "http://debian.neo4j.org/neotechnology.gpg.key",
		gpgcheck 	=> 1,
  	}

	# Install server package and make sure service is running..
	#
	package { 'neo4j':
		ensure 		=> installed,
		require		=> Yumrepo['neo4j']
	}

	service { 'neo4j': 
		require 	=> Package['neo4j'], 
	  	ensure 		=> running,
       	enable 		=> true
	}

}
