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
  $ensure = $activemq::ensure,
) {

  # Arrays cannot take anonymous arrays in Puppet 2.6.8
  $v_ensure = [ '^running$', '^stopped$' ]
  validate_re($ensure, $v_ensure)

  service { 'activemq':
    ensure     => $ensure,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['activemq::packages'],
  }

}
