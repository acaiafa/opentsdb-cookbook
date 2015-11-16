# OpenTSDB Test setup
# Since I do not think that this cookbook should tell you howto install or what cookbook to use to install java I will not be including it. For this test I will simply install the latest version so we can get on with the show.
#
case node.platform
when 'ubuntu'
  pkg = 'openjdk-7-jre-headless'

  # run apt-get since well yeah
  bash 'apt-get' do
    code <<-EOH
    apt-get update
    EOH
  end

when 'centos','rhel'
  pkg = 'java-1.7.0-openjdk-headless'
end

package pkg do
  action :install
end

opentsdb_instance 'test' do
  logback_level 'WARN'
end
