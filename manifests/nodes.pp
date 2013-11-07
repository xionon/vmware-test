node default {
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

  /*
    mysql client
    git
    memcached
    rvm
    application
  */
}

