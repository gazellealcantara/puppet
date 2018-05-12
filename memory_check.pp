$packages = [ 'yum', 'curl', 'git', 'wget' ]
package { $packages: ensure => 'installed' }

file { "/home/monitor":
  ensure => "directory",
}

user { 'monitor':
  ensure => present,
  home => "/home/monitor",
  shell => "/bin/bash",
}

file { "/home/monitor/scripts":
  ensure => "directory",
}

exec { "git":
  command => "/usr/bin/wget -q https://rawcdn.githack.com/gazellealcantara/memory-check/master/memory_check.sh -O /home/monitor/scripts/memory_check",
  path => "/home/monitor/scripts"
}

file { "/home/monitor/scripts/memory_check":
  ensure => "present",
  mode => "0755",
}

file { "/home/monitor/src":
  ensure => "directory",
}

file { "/home/monitor/src/my_memory_check":
  ensure => "link",
  target => "/home/monitor/scripts/memory_check",
}

cron { "memory check": 
  command => "/home/monitor/src/my_memory_check",
  user => monitor,
  hour => "*",
  minute => "*/10",
}

file { "/etc/localtime":
  ensure => "link",
  target => "/usr/share/zoneinfo/Asia/Manila",
}
