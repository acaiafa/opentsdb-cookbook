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
  user 'opentsdb'
  version '2.2.0'
  logback_level 'WARN'
end
