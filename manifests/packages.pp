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
  $version
) {

  validate_re($version, '^[._0-9a-zA-Z:-]+$')

  $version_real = $version

  package { 'activemq':
    ensure  => $version_real,
    notify  => Service['activemq'],
  }

  if $::osfamily == 'RedHat' {
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
}
