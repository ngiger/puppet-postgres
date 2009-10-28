class postgres::base::centos inherits postgres::base {
    package{'ruby-postgres':
        ensure => installed
    }
}
