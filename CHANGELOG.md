##2014-11-25 - Release 0.4.0
###Summary

This release adds a number of new paramters to the `activemq` class and also fixes some bugs, including the issue that was making this module unusable for newer versions of activemq!

####Features
- New parameters added to class `activemq`
  - `mq_broker_name`
  - `mq_admin_username`
  - `mq_admin_password`
  - `mq_cluster_username`
  - `mq_cluster_password`
  - `mq_cluster_brokers`

####Bugfixes
- Disable init script override for activemq >= 5.9 (MODULES-1459)
- Fix `issues_url` in metadata
- Set correct default ports for openwire and stomp transport connectors

##2014-07-15 - Release 0.3.1
###Summary

This release merely updates metadata.json so the module can be uninstalled and
upgraded via the puppet module command.

##2014-05-28 - Release 0.3.0
###Summary

This is primarily a bugfix release, but also adds the ability to configure
the package name.

####Features
- Make package name configurable.

####Bugfixes
- Update version regex to match versions seen in Debian and Ubuntu.
- Update erb to use instance variables
- Fix the license

##2013-09-26 - Release 0.2.0
###Summary

Adds Debian osfamily support and proper testing

####Backwards-incompatible changes

The module no longer manages the activemq user/group
and instead relies on the deb and rpm packages to do it.

####Features
- Add support for Debian osfamilies
- Add proper spec testing

##2011-06-21 - Release 0.1.6
###Summary

Add webconsole setting to enable console at http://localhost:8160/admin

##2011-06-17 - Release 0.1.5
###Summary

Add anchors to provider better relationship management

##2011-05-31 - Release 0.1.4
###Summary

Add server_config class parameter for re-usability

##2011-05-28 - Release 0.1.3
###Summary

Remove stages

##2011-05-25 - Release 0.1.2
###Summary

Fix validate_re calls to work with 2.6.8 arrays

##2011-05-25 - Release 0.1.1
###Summary

Updated version to 0.1.1 to follow semantic versioning

##2011-05-25 - Release 1.0.1
###Summary

Add validation

##2011-05-24 - Release 1.0.0
###Summary

Initial release
