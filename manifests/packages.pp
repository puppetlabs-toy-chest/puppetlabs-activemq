# Class: activemq::packages
#
#   ActiveMQ Packages
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class activemq::packages (
  $version,
  $home = '/usr/share/activemq'
) {

  validate_re($version, '^[._0-9a-zA-Z:-]+$')
  validate_re($home, '^/')

  $version_real = $version
  $home_real    = $home

  # Manage the user and group in Puppet rather than RPM
  group { 'activemq':
    ensure => 'present',
    gid    => '92',
    before => User['activemq']
  }
  user { 'activemq':
    ensure  => 'present',
    comment => 'Apache Activemq',
    gid     => '92',
    home    => '/usr/share/activemq',
    shell   => '/bin/bash',
    uid     => '92',
    before  => Package['activemq'],
  }
  file { $home_real:
    ensure => directory,
    owner  => '0',
    group  => '0',
    mode   => '0755',
    before => Package['activemq'],
  }

  package { 'activemq':
    ensure  => $version_real,
    notify  => Service['activemq'],
  }

  # JJM Fix the activemq init script always exiting with status 0
  # FIXME This should be corrected in the upstream packages
  file { '/etc/init.d/activemq':
    ensure  => file,
    path    => '/etc/init.d/activemq',
    content => template("${module_name}/init/activemq"),
    owner   => '0',
    group   => '0',
    mode    => '0755',
  }

}
