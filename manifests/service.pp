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
  if $ensure {
    # Arrays cannot take anonymous arrays in Puppet 2.6.8
    $v_ensure = [ '^running$', '^stopped$' ]
    validate_re($ensure, $v_ensure)
  }

  validate_bool($service_enable)

  $ensure_real = $ensure

  service { 'activemq':
    ensure     => $ensure_real,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['activemq::packages'],
  }

}
