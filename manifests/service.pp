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
  $ensure
) {

  validate_re($ensure, [ '^running$', '^stopped$' ])

  $ensure_real = $ensure

  service { 'activemq':
    ensure     => $ensure_real,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['activemq::packages'],
  }

}
