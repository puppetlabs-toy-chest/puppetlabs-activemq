# ActiveMQ #

This module configures ActiveMQ.  It is primarily designed to work with
MCollective and the Oracle Java runtime on an RHEL or EL variant.

 * [ActiveMQ](http://activemq.apache.org/)
 * [MCollective](http://www.puppetlabs.com/mcollective/introduction/)

# Quick Start #

The example in the tests directory provides a good example of how the ActiveMQ
module may be used.  In addition, the [MCollective
Module](http://forge.puppetlabs.com/puppetlabs/mcollective) provides a good
example of a service integrated with this ActiveMQ module.

    node default {
      notify { 'alpha': }
      ->
      class  { 'java':
        distribution => 'jdk',
        version      => 'latest',
      }
      ->
      class  { 'activemq': }
      ->
      notify { 'omega': }
    }

# Contact Information #

 * Jeff McCune <jeff@puppetlabs.com>
 * [Module Source Code](https://github.com/puppetlabs/puppetlabs-activemq)

# Related Work #

The [lab42-activemq](http://forge.puppetlabs.com/lab42/activemq) module
provided much of the basis for this module.

# Web Console #

The module manages the web console by default.  The web console port is usually
located at port 8160:

 * [http://localhost:8160/admin](http://localhost:8160/admin)

To disable this behavior, pass in webconsole => false to the class.  e.g.

    node default {
      class { 'activemq':
        webconsole => false,
      }
    }
    
# Custom configuration #    

    node default {
      class { 'activemq':
        server_config => template("${module_name}/activemq.xml.erb"),
      }
    }
    
# Install from binary #

If you do not have a activemq package ready for your favorite distribution, you can install it from the binary 

    node default {
      class { 'activemq':
        install_from_binary => true,
        package             => 'http://www.eu.apache.org/dist/activemq/5.13.0/apache-activemq-5.13.0-bin.tar.gz',
      }
    }