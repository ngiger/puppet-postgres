class postgres::server inherits postgres::common { include postgres::client

  notify{ "${postgres_cfg_path}/pg_hba.conf.1":}
  notify{ "$postgres_cfg_path/pg_hba.conf.2":}
# debian uses /etc/postgresql/<version>/  
  exec{"$postgres_cfg_path":
	command => "/bin/mkdir -p $postgres_cfg_path",
  }
  file{"$postgres_cfg_path":
	ensure =>  directory,
        recurse => true,
	owner => "postgres",
	group => "postgres",
	mode  =>  0700,
	require => Exec["$postgres_cfg_path"],
	}
  package{$postgres_server_pkg:
    ensure => present,
  }
  service{'postgresql':
    enable => true,
    ensure => running,
    hasstatus => true,
    require => [Package[$postgres_server_pkg],
      File[
	"${postgres_cfg_path}/postgresql.conf", 
	"${postgres_cfg_path}/pg_hba.conf"],
      ],
  }

  file{"${postgres_cfg_path}/postgresql.conf":
    source => [
      "modules/site-postgres/${fqdn}/postgresql.conf",
      "modules/site-postgres/postgresql.conf",
      "modules/postgres/postgresql.conf.${operatingsystem}",
      "modules/postgres/postgresql.conf"
    ],
    notify => Service[postgresql],
    require => Package[$postgres_server_pkg],
    owner => postgres, group => postgres, mode => 0600;
  }
  file{"${postgres_cfg_path}/pg_hba.conf":
    source => [
      "modules/site-postgres/${fqdn}/pg_hba.conf",
      "modules/site-postgres/pg_hba.conf",
      "modules/postgres/pg_hba.conf.${operatingsystem}",
      "modules/postgres/pg_hba.conf"
    ],
    notify => Service[postgresql],
    require => Package[$postgres_server_pkg],
    owner => postgres, group => postgres, mode => 0600;
  }

#  We want to do this per database in another package !!
#  file{"${postgres_base_path}/backups":
#    ensure => directory,
#    require => Package[$postgres_server_pkg],
#    recurse => true,
#    owner => postgres, group => postgres, mode => 0700;
#  }
#  file{'/etc/cron.d/pgsql_backup.cron':
#    source => "modules/postgres/pgsql_backup.cron",
#    require => File["${$postgres_base_path}/backups"],
#    owner => root, group => 0, mode => 0600;
#  }
  file{'/etc/cron.d/pgsql_vacuum.cron':
    source => "postgres/pgsql_vacuum.cron",
    require => Package[$postgres_server_pkg],
    owner => root, group => 0, mode => 0600;
  }
}
