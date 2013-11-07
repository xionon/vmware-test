node default {
  include apt
  file { '/etc/motd':
    content => "Provisioned by Puppet, 5-Nov-13",
  }
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

  /*
    rvm
    application
  */
}

node /^db-\d+$/ {
  include apt
  class {'mysql::server':
    require => Class['apt'],
  }
}

