#
# == Class: nfs::server::redhat
#
# NFS server
# TODO: add NFS v4 support
#
class nfs::server::redhat inherits nfs::client::redhat {

  @concat {'/etc/exports':
    owner  => root,
    group  => root,
    mode   => '0644',
    notify => Service['nfs-server'],
  }

  service{ 'nfs-server':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    restart   => '/bin/systemctl reload nfs-server',
    require   => [Package[ 'nfs-utils' ], Service[ 'rpcbind' ]],
  }

}
