define servicemix::smx-relink($src = '', $dest = '') {

	include servicemix
		
	exec { "smx-relink-${src}-${dest}":
		require			=> File['/opt/servicemix/smx-relink.sh'],
		command			=> "/opt/servicemix/smx-relink.sh ${src} ${dest}",
		user			=> root,
	}
	
	

}