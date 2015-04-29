  define mariadb::passwd ($pwd){
      exec { "set-mysql-password":
          unless => "mysqladmin -u$name -p$pwd status",
          path => ["/bin", "/usr/bin"],
          command => "mysqladmin -u$name password $pwd",
          require => Service["mysql"]
     }
  }

