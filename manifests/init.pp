#
# postgres module
#
# Copyright 2008, Puzzle ITC
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#
# Module is base on the one from the immerda project
# https://git.puppet.immerda.ch/module-pgsql
# as well on Luke Kanies 
# http://github.com/lak/puppet-postgres/tree/master
#
# modules_dir { \"postgres\": }

class postgres {
    case $operatingsystem {
        gentoo: { include postgres::gentoo } 
        centos: { include postgres::centos } 
        default: { include postgres::base }
    }
}

class postgres::base {
    package { 'postgresql':
        ensure => present,
    }

    service{'postgresql':
        enable => true,
        ensure => running,
        hasstatus => true,
        require => Package[postgresql],
    }

    file{'/etc/cron.d/pgsql_backup.cron':
        source => "puppet://$server/postgres/backup/pgsql_backup.cron",
        owner => root, group => 0, mode => 0600;
    }

    if $use_munin {
        include munin::plugins::postgres
    }
}

class postgres::gentoo inherits postgres::base {
    Package['postgresql']{
        category => 'dev-db',
    }
}

class postgres::centos inherits postgres::base {
	package { [ruby-postgres, postgresql-server]: ensure => installed }

    Service[postgresql]{
        require +> [ Package[postgresql-server] ],
    }
}
