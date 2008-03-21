# modules/pgsql/manifests/init.pp - manage pgsql stuff
# Copyright (C) 2007 admin@immerda.ch
# GPLv3

# modules_dir { "pgsql": }

class pgsql::server {
    package { 'postgresql':
        ensure => present,
        category => $operatingsystem ? {
            gentoo => 'dev-db',
            default => '',
        }
    }

    service{'postgresql':
        enable => true,
        ensure => running,
        require => Package[postgresql],
    }

    include munin::plugins::postgres
}

