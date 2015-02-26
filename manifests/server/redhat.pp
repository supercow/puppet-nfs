#
# == Class: nfs::server::redhat
#
# NFS server
# TODO: add NFS v4 support
#
class nfs::server::redhat inherits nfs::client::redhat {

  $service_name = $::operatingsystemmajrelease ? {
    /(5|6)/ => 'nfs',
    '7'     => 'nfs-server',
  }

  @concat {'/etc/exports':
    owner  => root,
    group  => root,
    mode   => '0644',
    notify => Service[$service_name],
  }

  service{ $service_name:
    ensure    => running,
    enable    => true,
    hasstatus => true,
    restart   => '/bin/systemctl reload nfs-server',
    require   => [Package[ 'nfs-utils' ], Service[ 'rpcbind' ]],
  }

}
