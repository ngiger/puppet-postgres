class postgres::base {
    include postgres::client

    package{'postgresql-server':
        ensure => present,
    }
    service{'postgresql':
        enable => true,
        ensure => running,
        hasstatus => true,
        require => Package[postgresql-server],
    }
    file{'/var/lib/pgsql/backups':
        ensure => directory,
        require => Service[postgresql],
        owner => postgres, group => postgres, mode => 0700;
    }
    file{'/var/lib/pgsql/data/pg_hba.conf':
            source => [
                "puppet://$server/site-postgres/${fqdn}/pg_hba.conf",
                "puppet://$server/site-postgres/pg_hba.conf",
                "puppet://$server/postgres/config/pg_hba.conf.${operatingsystem}",
                "puppet://$server/postgres/config/pg_hba.conf"
            ],
            notify => Service[postgresql],
            require => Service[postgresql],
            owner => postgres, group => postgres, mode => 0600;
    }
    file{'/var/lib/pgsql/data/postgresql.conf':
            source => [
                "puppet://$server/site-postgres/${fqdn}/postgresql.conf",
                "puppet://$server/site-postgres/postgresql.conf",
                "puppet://$server/postgres/config/postgresql.conf.${operatingsystem}",
                "puppet://$server/postgres/config/postgresql.conf"
            ],
            notify => Service[postgresql],
            require => Service[postgresql],
            owner => postgres, group => postgres, mode => 0600;
    }
    file{'/etc/cron.d/pgsql_backup.cron':
        source => "puppet://$server/postgres/backup/pgsql_backup.cron",
        require => File['/var/lib/pgsql/backups'],
        owner => root, group => 0, mode => 0600;
    }
    file{'/etc/cron.d/pgsql_vacuum.cron':
        source => "puppet://$server/postgres/maintenance/pgsql_vacuum.cron",
        owner => root, group => 0, mode => 0600;
    }
    if $use_munin {
        include postgres::munin
    }
}
