# Specific settings for client on Redhat distribution.
class nfs::client::redhat inherits nfs::base {

  package { 'nfs-utils':
    ensure => present,
  }

  if $::operatingsystemmajrelease == 6 or $::operatingsystemmajrelease == 7 {

    package {'rpcbind':
      ensure => present,
    }

    service {'rpcbind':
      ensure    => running,
      enable    => true,
      hasstatus => true,
      require   => [Package['rpcbind'], Package['nfs-utils']],
    }

  } else {

    package { 'portmap':
      ensure => present,
    }

    service { 'portmap':
      ensure    => running,
      enable    => true,
      hasstatus => true,
      require   => [Package['portmap'], Package['nfs-utils']],
    }

  }

  $nfslock_requirement = $::operatingsystemmajrelease ? {
    /(6|7)/ => Service['rpcbind'],
    default => [Package['portmap'], Package['nfs-utils']]
  }

  $nfslock_name = $::operatingsystemmajrelease ? {
    7       => 'nfs-lock',
    default => 'nfslock',
  }

  service {$nfslock_name:
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => $nfslock_requirement,
  }

  $netfs_requirement = $::operatingsystemmajrelease ? {
    6       => Service[$nfslock_name],
    default => [Service['portmap'], Service[$nfslock_name]],
  }


  if $::operatingsystemmajrelease =~ /(5|6)/ {
    service { 'netfs':
      enable  => true,
      require => $netfs_requirement,
    }
  }

}
