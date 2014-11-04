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
  $package
) {

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')

  $version_real = $version
  $package_real = $package

  package { $package_real:
    ensure  => $version_real,
    notify  => Service['activemq'],
  }
}
