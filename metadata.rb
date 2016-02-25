name 'opentsdb'
maintainer 'Anthony Caiafa'
maintainer_email 'acaiafa1@bloomberg.net'
description 'Application cookbook which installs and configures OpenTSDB.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.1.8'

supports 'redhat', '>= 5.8'
supports 'centos', '>= 5.8'
supports 'ubuntu', '>= 12.04'

depends 'java'
depends 'poise', '~> 2.2'
depends 'poise-service', '~> 1.0'
