class ladok-dummy-webserver {
        
  	package { "httpd":
   		ensure	=> present
 	}
        
  	service { "httpd":
     	ensure	=> running,
    	require	=> Package["httpd"]
  	}
        
 	file { "/var/www/html/ladok":
  		source	=> "puppet:///modules/ladok-dummy-webserver/ladok",
  		recurse	=> true
	}
	
}

