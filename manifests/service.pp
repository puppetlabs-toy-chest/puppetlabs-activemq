# Class: activemq::service
#
#   Manage the ActiveMQ Service
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class activemq::service(
  $ensure,
  $service_enable = $::activemq::params::service_enable
) {

  # Arrays cannot take anonymous arrays in Puppet 2.6.8
  $v_ensure = [ '^running$', '^stopped$' ]
  validate_re($ensure, $v_ensure)

  validate_bool($service_enable)

  $ensure_real = $ensure

  service { 'activemq':
    enable     => $service_enable,
    ensure     => $ensure_real,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['activemq::packages'],
  }

}
