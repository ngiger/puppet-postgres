# manifests/disable.pp

class postgres::disable {
    case $operatingsystem {
        centos: { include postgres::centos::disable }
        default: { include postgres::base::disable }
    }
}

class postgres::base::disable inherits postgres::base {
    Service['postgresql']{
        ensure => stopped,
        enable => false,
    }

    File['/etc/cron.d/pgsql_backup.cron', '/etc/cron.d/pgsql_vacuum.cron']{
        ensure => absent,
    }

}

class postgres::centos::disable inherits postgres::centos { 
    include postgres::base::disable
}
