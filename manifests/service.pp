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

  # JJM FIXME Validation!
  $ensure_real = $ensure

  # JJM FIXME Manage the service
  service { 'activemq':
    ensure     => $ensure_real,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['activemq::packages'],
  }

}
