name             'postgres-hardening'
maintainer       'Christoph Hartmann'
maintainer_email 'chris@lollyrock.com'
license          'Apache-2.0'
description      'Installs and configures a secure posgres server'
version          '2.0.0'

depends 'postgresql', '>= 6.0.0'

supports 'amazon'
supports 'redhat'
supports 'centos'
supports 'fedora'
supports 'debian'
supports 'ubuntu'

source_url 'https://github.com/dev-sec/chef-postgres-hardening'
issues_url 'https://github.com/dev-sec/chef-postgres-hardening/issues'
