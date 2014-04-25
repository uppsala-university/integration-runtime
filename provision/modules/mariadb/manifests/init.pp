class mariadb {

	# MariaDB is not in default repository. Install.
	#
	yumrepo { "MariaDB":
		baseurl 	=> "http://yum.mariadb.org/5.5/centos6-amd64",
		descr		=> "MariaDB distribution from mariadb.org",
		enabled 	=> 1,
		gpgkey 		=> "https://yum.mariadb.org/RPM-GPG-KEY-MariaDB",
		gpgcheck 	=> 1,

        }

	# Install server and client.
	#
	package { 'MariaDB-server':
		ensure 		=> installed 
	}

	package { 'MariaDB-client':
		require 	=> Package['MariaDB-server'],
		ensure 		=> installed 
	}

	service { 'mysql': 
		require 	=> Package['MariaDB-server'], 
       		ensure 		=> running,
        	enable 		=> true
	}

}
