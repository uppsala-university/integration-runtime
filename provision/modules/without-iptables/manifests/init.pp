class without-iptables {
	service{ "iptables":
  		ensure          => stopped
  	}
}