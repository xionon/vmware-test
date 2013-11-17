node default {
  include apt
  file { '/etc/motd':
    content => "Provisioned by Puppet, 5-Nov-13",
  }
}

node /^proxy-\d+$/ {
  include varnish
  include varnish::vcl
  class { 'nginx': }
  nginx::resource::upstream { 'varnish':
    ensure  => present,
    members => [
      'localhost:8080',
    ],
  }

  nginx::resource::vhost { '*.conductor.dev':
    listen_port => '80 default_server',
    access_log  => '/var/log/nginx/star.conductor.dev.access.log',
    error_log   => '/var/log/nginx/star.conductor.dev.error.log',
    ensure      => present,
    proxy       => 'http://varnish',
  }
}

node /^app-\d+$/ {
  include apt
  package{ 'imagemagick':
    ensure => present,
  }

  class {'apache':
    require => Class['apt'],
  }

  include mysql::client

  package{'git':
    ensure => present,
  }

  package{'memcached':
    ensure => present,
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

