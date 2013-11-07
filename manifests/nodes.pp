node default {
  file { '/etc/motd':
    content => "Provisioned by Puppet, 5-Nov-13",
  }
}

node /^app-\d+$/ {
  class {'apt':
    always_apt_update => true,
  }

  class {'apache': 
    require => Class['apt'],
  }
}

