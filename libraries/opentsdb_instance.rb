#
# Cookbook: opentsdb
# License: Apache 2.0
#
# Copyright (C) 2015 Bloomberg Finance L.P.
#
require 'poise_service/service_mixin'
require_relative 'helpers'

module OpentsdbCookbook
  module Resource
    # @since 1.0.0
    class OpentsdbInstance < Chef::Resource
      include Poise
      provides(:opentsdb_instance)
      include PoiseService::ServiceMixin

      # @!attribute config_name
      # @return [String]
      attribute(:instance_name, kind_of: String, name_attribute: true)

      # @!attribute version
      # @return [String, NilClass]
      attribute(:version, kind_of: String, default: '2.1.0')

      # @attribute package_url
      # @return [String]
      attribute(:package_url, kind_of: String, default: "https://github.com/OpenTSDB/opentsdb/releases/download/v#{new_resource.version}/opentsdb-#{new_resource.version}#{distro_ext}")

      # @!attribute user
      # @return [String]
      attribute(:user, kind_of: String, default: 'opentsdb')

      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'opentsdb')

      # @see: https://github.com/OpenTSDB/opentsdb/blob/master/src/opentsdb.conf
      # @see: http://opentsdb.net/docs/build/html/user_guide/configuration.html
      attribute(:port, kind_of: Integer, default: 4242)
      attribute(:bind, kind_of: String, default: '0.0.0.0')
      # Network Configuration Parameters
      attribute(:network_tcpnodelay, kind_of: [TrueClass, FalseClass], default: true)
      attribute(:network_keepalive, kind_of: [TrueClass, FalseClass], default: true)
      attribute(:network_reuseaddress, kind_of: [TrueClass, FalseClass], default: true)
      attribute(:network_worker_threads, kind_of: Integer)
      attribute(:network_async_io, kind_of: [TrueClass, FalseClass], default: true)
      attribute(:network_backlog, kind_of: String)


      # HTTP Configuration Parameters
      attribute(:http_staticroot, kind_of: String, default: '/usr/share/opentsdb/static/')
      attribute(:http_cachedir, kind_of: String, default: '/tmp/opentsdb')
      attribute(:http_request_cors_domains, kind_of: String)
      attribute(:http_request_cors_headers, kind_of: String, default: 'Authorization, Content-Type, Accept, Origin, User-Agent, DNT, Cache-Control, X-Mx-ReqToken, Keep-Alive, X-Requested-With, If-Modified-Since')
      attribute(:http_request_enable_chunked, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:http_request_max_chunk, kind_of: Integer, default: 4096)
      attribute(:http_show_stack_trace, kind_of: [TrueClass,FalseClass], default: false)

      # Core Configuration Parameters
      attribute(:core_auto_create_metrics, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:core_plugin_path, kind_of: String, default: '/usr/share/opentsdb/plugins')
      attribute(:core_auto_create_tagks, kind_of: [TrueClass, FalseClass], default: true)
      attribute(:core_auto_create_tagvs, kind_of: [TrueClass, FalseClass], default: true)
      attribute(:core_meta_enable_realtime_ts, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:core_meta_enable_realtime_uid, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:core_meta_enable_tsuid_incrementing, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:core_meta_enable_tsuid_tracking, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:core_preload_uid_cache, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:core_preload_uid_cache_max_entries, kind_of: String, default: '300,000')
      attribute(:core_timezone, kind_of: String)
      attribute(:core_tree_enable_processing, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:core_uid_random_metrics, kind_of: [TrueClass, FalseClass], default: false)

      # Storage Configuration Parameters
      attribute(:storage_enable_compaction, kind_of: [TrueClass, FalseClass], default: true)
      attribute(:storage_fix_duplicates, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:storage_flush_interval, kind_of: String, default: '1000')
      attribute(:storage_hbase_data_table, kind_of: String, default: 'tsdb')
      attribute(:storage_hbase_uid_table, kind_of: String, default: 'tsdb-uid')
      attribute(:storage_meta_table, kind_of: String, default: 'tsdb-meta')
      attribute(:storage_tree_table, kind_of: String, default: 'tsdb-tree')
      attribute(:storage_hbase_zk_basedir, kind_of: String, default: '/hbase')
      attribute(:storage_hbase_zk_quorum, kind_of: String, default: 'localhost')

      # Search/RPC/RTPublisher/Stats/Misc Configuration Paramters
      attribute(:search_enable, kind_of: [TrueClass,FalseClass], default: false)
      attribute(:search_plugin, kind_of: String)
      attribute(:mode, equal_to: %w{rw ro}, default: 'rw')
      attribute(:no_diedie, kind_of: [TrueClass,FalseClass], default: false)
      attribute(:rtpublisher_enable, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:rtpublisher_plugin, kind_of: String)
      attribute(:stats_canonical, kind_of: [TrueClass, FalseClass], default: false)
    end
  end

  module Provider
    # @since 1.0.0
    class OpentsdbInstance < Chef::Provider
      include Poise
      provides(:opentsdb_instance)
      include PoiseService::ServiceMixin
      include OpentsdbCookbook::Helpers

      # Installs and sets up the tsdb package and configuration.
      # @since 1.0.0
      def action_enable
        notifying_block do
          # Install Packages
          remote_file "#{new_resource.instance_name} :create /tmp/opentsdb-#{new_resource.version}#{distro_ext}" do
            source new_resource.package_url
            action :create
          end

          package "opentsdb-#{version}#{distro_ext}" do
            source "/tmp/opentsdb-#{version}#{distro_ext}"
            action :upgrade
          end
        end
        super
      end

      # Deletes and removes configuration for the tsdb instance.
      def service_options(service)
        service.service_name('opentsdb')
        service.command(start_command)
        service.directory('/var/run/opentsdb')
        service.user('opentsdb')
        service.restart_on_update(true)
      end
    end
  end
end
