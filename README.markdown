ActiveMQ
========

This module configures ActiveMQ.  It uses the Apache ActiveMQ binary package
and the Java runtime.

 * [ActiveMQ](http://activemq.apache.org/)
 * [MCollective](http://www.puppetlabs.com/mcollective/introduction/)

Quick Start
-----------

The example in the tests directory provides a good example of how the ActiveMQ
module may be used.  In addition, the [MCollective
Module](http://forge.puppetlabs.com/fsalum/mcollective) provides a good
example of a service integrated with this ActiveMQ module.

    node default {
      class  { 'java':
        distribution => 'jdk',
        version      => 'latest',
      }

      class  { 'activemq': }
    }

Change the default user/password for mcollective and admin:

    class  { 'activemq':
      webconsole       => true,
      stomp_user       => 'mcollective',
      stomp_passwd     => 'marionette',
      stomp_admin      => 'admin',
      stomp_adminpw    => 'secret',
      activemq_mem_min => '1G',
      activemq_mem_max => '1G',
    }

The activemq_mem_min and activemq_mem_max were added in order to customize
the memory when using Vagrant.

Contact Information
-------------------

 * Felipe Salum <fsalum@gmail.com>
 * [Module Source Code](https://github.com/fsalum/puppetlabs-activemq)

Related Work
------------

This module is a fork from [puppetlabs-activemq](https://github.com/puppetlabs/puppetlabs-activemq)
but instead of using the Linux distro package it uses the binary distribution
from [Apache ActiveMQ](http://activemq.apache.org).

Web Console
-----------

The module manages the web console by default.  The web console port is usually
located at port 8161:

 * [http://localhost:8160/admin](http://localhost:8161/admin)

To disable this behavior, pass in webconsole => false to the class.  e.g.

    node default {
      class { 'activemq':
        webconsole => false,
      }
    }

