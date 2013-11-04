node default {
  file { '/etc/motd':
    content => "Provisioned by Puppet",
  }
}

node /^app-\d+$/ {
  file{ '/etc/motd':
    content => "Application node\nProvisioned by Puppet",
  }
}

