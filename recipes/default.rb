#
# Cookbook: opentsdb
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
#
node.default['java']['jdk_version'] = '8'
node.default['java']['accept_license_agreement'] = true
include_recipe 'java::default'

opentsdb_instance node['opentsdb']['service_name']
