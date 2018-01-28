# Class: hp_ssa
# ===========================
#
# Full description of class hp_ssa here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'hp_ssa':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class hp_ssa (
    String $mcp_version = 'current',
    Boolean $install_ams = false,
) {
    case $::operatingsystem {
        'CentOS': {
            file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-HP-mcp':
                ensure => file,
                source => 'puppet:///modules/hp_ssa/RPM-GPG-KEY-HP-mcp',
            }

            yumrepo { 'HP-mcp':
                descr    => 'HP Software Delivery Repository for Management Component Pack',
                enabled  => 1,
                gpgcheck => 1,
                gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-HP-mcp',
                baseurl  => "http://downloads.linux.hpe.com/repo/mcp/centos/\$releasever/\$basearch/${mcp_version}/",
                require  => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-HP-mcp'],
            }

            package { 'ssacli':
                ensure  => 'installed',
                require => Yumrepo['HP-mcp'],
            }

            if ($install_ams) {
                package { 'hp-ams':
                    ensure => 'installed',
                }
            }
        }
        default: {
            fail('Can only be installed on CentOS.')
        }
    }
}
