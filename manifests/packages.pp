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
  $home = '/opt/activemq',
  $activemq_binary_version,
  $activemq_mem_min,
  $activemq_mem_max,
) {

  validate_re($version, '^[._0-9a-zA-Z:-]+$')
  validate_re($home, '^/')

  $version_real                 = $version
  $home_real                    = $home
  $activemq_binary_version_real = $activemq_binary_version

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
    home    => '/opt/activemq',
    shell   => '/bin/bash',
    uid     => '92',
    before  => Exec['activemq_pkg'],
  }

  #package { 'activemq':
  #  ensure  => $version_real,
  #  notify  => Service['activemq'],
  #}

  file { "/opt/${activemq_binary_version_real}-bin.tar.gz":
    ensure => present,
    source => "puppet:///modules/activemq/${activemq_binary_version_real}-bin.tar.gz",
    notify => Exec['activemq_pkg'],
  }

  exec { 'activemq_pkg':
    path    => '/usr/bin:/usr/sbin:/bin',
    command => "tar zxvf /opt/${activemq_binary_version_real}-bin.tar.gz -C /opt",
    user    => root,
    group   => root,
    creates => "/opt/${activemq_binary_version_real}",
    require => File["/opt/${activemq_binary_version_real}-bin.tar.gz"],
    notify  => File['activemq_init'],
  }

  file { 'activemq_init':
    ensure  => file,
    path    => '/etc/init.d/activemq',
    owner   => '0',
    group   => '0',
    mode    => '0755',
    content => template('activemq/activemq.init.erb'),
  }

  file { $home_real:
    ensure  => link,
    target  => "/opt/${activemq_binary_version_real}",
    require => Exec['activemq_pkg'],
    notify  => Service['activemq'],
  }

}
