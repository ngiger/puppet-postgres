class postgres::server {
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
    exec{'initialize_postgres_database':
        command => '/etc/init.d/postgresql start; /etc/init.d/postgresql stop',
        creates => '/var/lib/pgsql/data/postgresql.conf',
        require => Package[postgresql-server],
        before => [
            File['/var/lib/pgsql/data/pg_hba.conf'], 
            File['/var/lib/pgsql/data/postgresql.conf']
        ],
    }
    file{'/var/lib/pgsql/data/postgresql.conf':
        source => [
            "puppet://$server/site-postgres/${fqdn}/postgresql.conf",
            "puppet://$server/site-postgres/postgresql.conf",
            "puppet://$server/postgres/postgresql.conf.${operatingsystem}",
            "puppet://$server/postgres/postgresql.conf"
        ],
        notify => Service[postgresql],
        require => Package[postgresql-server],
        owner => postgres, group => postgres, mode => 0600;
    }
    file{'/var/lib/pgsql/data/pg_hba.conf':
        source => [
            "puppet://$server/site-postgres/${fqdn}/pg_hba.conf",
            "puppet://$server/site-postgres/pg_hba.conf",
            "puppet://$server/postgres/pg_hba.conf.${operatingsystem}",
            "puppet://$server/postgres/pg_hba.conf"
        ],
        notify => Service[postgresql],
        require => Package[postgresql-server],
        owner => postgres, group => postgres, mode => 0600;
    }
    file{'/var/lib/pgsql/backups':
        ensure => directory,
        require => Package[postgresql-server],
        owner => postgres, group => postgres, mode => 0700;
    }
    file{'/etc/cron.d/pgsql_backup.cron':
        source => "puppet://$server/postgres/pgsql_backup.cron",
        require => File['/var/lib/pgsql/backups'],
        owner => root, group => 0, mode => 0600;
    }
    file{'/etc/cron.d/pgsql_vacuum.cron':
        source => "puppet://$server/postgres/pgsql_vacuum.cron",
        require => Package[postgresql-server],
        owner => root, group => 0, mode => 0600;
    }
}
