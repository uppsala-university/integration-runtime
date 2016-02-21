class withoutiptables {
	service{ "iptables":
  	ensure	=> stopped
  }
}
