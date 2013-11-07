node default {
  include apt
  file { '/etc/motd':
    content => "Provisioned by Puppet, 5-Nov-13",
  }
}

node /^proxy-\d+$/ {
}

node /^app-\d+$/ {
  include apt
  package{ 'imagemagick':
    ensure => 'present',
  }

  class {'apache':
    require => Class['apt'],
  }

  include mysql::client

  package{'git':
    ensure => 'present',
  }

  package{'memcached':
    ensure => 'present',
  }

  group { 'deploy':
    ensure => present,
    gid    => 502,
  } ~> user { 'deploy':
    ensure     => present,
    uid        => 502,
    gid        => 502,
    shell      => '/bin/bash',
    home       => '/home/deploy',
    managehome => true,
  }

  rbenv::install { "deploy":
    group   => 'deploy',
    home    => '/home/deploy',
    require => User['deploy'],
  } ~> rbenv::compile {"2.0.0-p247":
    user    => 'deploy',
    home    => '/home/deploy',
  }

  /*
    application
  */
}

node /^db-\d+$/ {
  include apt
  class {'mysql::server':
    require => Class['apt'],
  }
}

