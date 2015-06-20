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
  $version             = $activemq::version,
  $package             = $activemq::package,
  $install_from_source = $activemq::install_from_source,
  $user                = $activemq::user,
  $group               = $activemq::group,
  $activemq_home       = $activemq::home,
  $config_path         = $activemq::config_path,
) {

  validate_re($version, '^[~+._0-9a-zA-Z:-]+$')
  validate_bool($install_from_source)

  unless $install_from_source {
    package { $package:
      ensure => $version,
      notify => Class['activemq::service'],
    }
  }

  if $install_from_source {
    include staging

    file { '/etc/init.d/activemq':
      ensure  => file,
      content => template("${module_name}/init/default/activemq"),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    }

    # Manage user and group only if installed from source, it is managed by
    # packaging system otherwise
    group { $group:
      ensure => 'present',
      system => true,
    }

    user { $user:
      ensure     => 'present',
      gid        => $group,
      home       => $activemq_home,
      managehome => false,
      system     => true,
      shell      => '/bin/false',
      require    => Group[$group],
    }

    validate_absolute_path($activemq_home)
    validate_re(
      $package,
      '^(http?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      "Expected to `package' parameter be a valid HTTP URI, when
      `install_from_source' is true."
    )

    file { $activemq_home:
      ensure  => directory,
      owner   => $user,
      group   => $group,
      require => User[$user],
    }

    $filename = regsubst($package, '.*/(.*)', '\1')

    if ! defined(Staging::File[$filename]) {
      staging::file { $filename:
        source  => $package,
        timeout => 0,
      }
    }

    staging::extract { $filename:
      source  => "${::staging::path}/activemq/${filename}",
      target  => $activemq_home,
      require => [Staging::File[$filename], File[$activemq_home]],
      unless  => "test \"\$(ls -A ${activemq_home})\"",
      strip   => 1,
      user    => $user,
      group   => $group,
    }

  # Has been reworked in 5.9 and no longer needed
  } elsif $::osfamily == 'RedHat' and ($version == 'present' or versioncmp($version, '5.9') < 0) {

  # JJM Fix the activemq init script always exiting with status 0
  # FIXME This should be corrected in the upstream packages
    file { '/etc/init.d/activemq':
      ensure  => file,
      content => template("${module_name}/init/redhat/activemq"),
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
    }
  }
}
