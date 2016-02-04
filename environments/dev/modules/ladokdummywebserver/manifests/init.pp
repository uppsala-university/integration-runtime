class ladokdummywebserver {
        
  package { "httpd":
   		ensure	=> present
 	}

  service { "httpd":
     	ensure	=> running,
    	require	=> Package["httpd"]
  }

 	file { "/var/www/html/ladok":
  		source	=> "puppet:///modules/ladokdummywebserver/ladok",
  		recurse	=> true
	}

}
