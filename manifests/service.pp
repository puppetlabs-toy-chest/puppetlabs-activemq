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

  # Allow ensure to be undef
  # Arrays cannot take anonymous arrays in Puppet 2.6.8
  $v_ensure = [ '^running$', '^stopped$', '^UNSET$' ]
  validate_re($ensure, $v_ensure)

  validate_bool($service_enable)

  $ensure_real = $ensure ? {
    'UNSET' => undef,
    default => $ensure,
  }

  service { 'activemq':
    ensure     => $ensure_real,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['activemq::packages'],
  }

}
