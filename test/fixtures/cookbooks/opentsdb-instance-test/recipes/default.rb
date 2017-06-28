platform_family = node.attribute?('platform_family') ? node['platform_family'] : node['platform_version']

case platform_family
when 'ubuntu', 'debian'
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

opentsdb_instance 'opentsdb-write' do
  user 'opentsdb'
  version '2.2.0'
  port 4300
  jmx_port 10201
  mode 'rw'
  java_home '/usr/lib/jvm/java-7-openjdk-amd64'
  logback_configfile "/etc/opentsdb/opentsdb-write_logback.xml"
  logback_level 'WARN'
  custom_plugin_options ({ 'opt1' => 123, 'opt2' => 'tst' })
end

opentsdb_instance 'opentsdb-read' do
  user 'opentsdb'
  version '2.2.0'
  port 4400
  jmx_port 10202
  java_home '/usr/lib/jvm/java-7-openjdk-amd64'
  mode 'ro'
  logback_configfile "/etc/opentsdb/opentsdb-read_logback.xml"
  logback_level 'WARN'
end
