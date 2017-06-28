#
# Cookbook: opentsdb
# License: Apache 2.0
#
# Copyright 2015-2016, Bloomberg Finance L.P.
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

      # @!attribute instance
      # @return [String]
      attribute(:instance, kind_of: String, name_attribute: true)

      # @!attribute cookbook
      # @return [String]
      attribute(:cookbook, kind_of: String, default: 'opentsdb')

      # @!attribute version
      # @return [String, NilClass]
      attribute(:version, kind_of: String, default: '2.1.0')

      # @attribute package_url
      # @return [String]
      attribute(:package_url, kind_of: String)

      # @!attribute user
      # @return [String]
      attribute(:user, kind_of: String, default: 'root')

      # @!attribute group
      # @return [String]
      attribute(:group, kind_of: String, default: 'root')

      # @!attribute config_dir
      # @return [String]
      attribute(:config_dir, kind_of: String, default: '/etc/opentsdb')

      # @!attribute java_home
      # @return [String]
      attribute(:java_home, kind_of: String, default: ENV['JAVA_HOME'])

      # @!attribute source
      # @return [String]
      attribute(:source_dir, kind_of: String, default: 'etc/opentsdb')

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
      attribute(:http_query_allow_delete, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:http_request_cors_domains, kind_of: String)
      attribute(:http_request_cors_headers, kind_of: String, default: 'Authorization, Content-Type, Accept, Origin, User-Agent, DNT, Cache-Control, X-Mx-ReqToken, Keep-Alive, X-Requested-With, If-Modified-Since')
      attribute(:http_request_enable_chunked, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:http_request_max_chunk, kind_of: Integer, default: 4096)
      attribute(:http_show_stack_trace, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:http_rpc_plugins, kind_of: String)

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
      attribute(:core_storage_exception_handler_enable, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:core_storage_exception_handler_plugin, kind_of: String)

      # Storage Configuration Parameters
      attribute(:storage_enable_compaction, kind_of: [TrueClass, FalseClass], default: true)
      attribute(:storage_fix_duplicates, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:storage_flush_interval, kind_of: String, default: '1000')
      attribute(:storage_hbase_data_table, kind_of: String, default: 'tsdb')
      attribute(:storage_hbase_uid_table, kind_of: String, default: 'tsdb-uid')
      attribute(:storage_hbase_meta_table, kind_of: String, default: 'tsdb-meta')
      attribute(:storage_hbase_tree_table, kind_of: String, default: 'tsdb-tree')
      attribute(:storage_hbase_zk_basedir, kind_of: String, default: '/hbase')
      attribute(:storage_hbase_zk_quorum, kind_of: String, default: 'localhost')
      attribute(:storage_compaction_flush_interval, kind_of: String, default: '10')
      attribute(:storage_compaction_flush_speed, kind_of: String, default: '2')
      attribute(:storage_compaction_max_concurrent_flushes, kind_of: String, default: '10000')
      attribute(:storage_compaction_min_flush_threshold, kind_of: String, default: '100')
      attribute(:storage_enable_appends, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:storage_hbase_prefetch_meta, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:storage_repair_appends, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:storage_max_tags, kind_of: String, default: '8')
      attribute(:storage_salt_buckets, kind_of: String, default: '20')
      attribute(:storage_salt_width, kind_of: String, default: '0')
      attribute(:storage_uid_width_metric, kind_of: String, default: '3')
      attribute(:storage_uid_width_tagk, kind_of: String, default: '3')
      attribute(:storage_uid_width_tagv, kind_of: String, default: '3')

      # Query configuration Parameters
      attribute(:query_allow_simultaneous_duplicates, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:query_filter_expansion_limit, kind_of: String, default: '4096')
      attribute(:query_skip_unresolved_tagvs, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:query_timeout, kind_of: String, default: '0')

      # Search/RPC/RTPublisher/Stats/Misc Configuration Paramters
      attribute(:search_enable, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:search_plugin, kind_of: String)
      attribute(:mode, equal_to: %w{rw ro}, default: 'rw')
      attribute(:no_diedie, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:rtpublisher_enable, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:rtpublisher_plugin, kind_of: String)
      attribute(:stats_canonical, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:rpc_plugins, kind_of: String)

      # HBASE Options
      attribute(:hbase_client_retries_number, kind_of: String, default: '10')
      attribute(:hbase_increments_buffer_size, kind_of: String, default: '65535')
      attribute(:hbase_ipc_client_connection_idle_timeout, kind_of: String, default: '300')
      attribute(:hbase_ipc_client_socket_receiveBufferSize, kind_of: String)
      attribute(:hbase_ipc_client_socket_sendBufferSize, kind_of: String)
      attribute(:hbase_ipc_client_socket_timeout_connect, kind_of: String, default: '5000')
      attribute(:hbase_ipc_client_tcpkeepalive, kind_of: [TrueClass, FalseClass], default: true)
      attribute(:hbase_ipc_client_tcpnodelay, kind_of: [TrueClass, FalseClass], default: true)
      attribute(:hbase_kerberos_regionserver_principal, kind_of: String)
      attribute(:hbase_nsre_high_watermark, kind_of: String, default: '10000')
      attribute(:hbase_nsre_low_watermark, kind_of: String, default: '100')
      attribute(:hbase_region_client_check_channel_write_status, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:hbase_region_client_inflight_limit, kind_of: String, default: '0')
      attribute(:hbase_region_client_pending_limit, kind_of: String, default: '0')
      attribute(:hbase_regionserver_kerberos_password, kind_of: String)
      attribute(:hbase_rpcs_batch_size, kind_of: String, default: '1024')
      attribute(:hbase_rpcs_buffered_flush_interval, kind_of: String, default: '1000')
      attribute(:hbase_rpc_protection, kind_of: String)
      attribute(:hbase_rpc_timeout, kind_of: String, default: '0')
      attribute(:hbase_sasl_clientconfig, kind_of: String, default: 'Client')
      attribute(:hbase_security_auth_94, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:hbase_security_auth_enable, kind_of: [TrueClass, FalseClass], default: false)
      attribute(:hbase_security_authentication, kind_of: String)
      attribute(:hbase_security_simple_username, kind_of: String)
      attribute(:hbase_timer_tick, kind_of: String, default: '20')
      attribute(:hbase_timer_ticks_per_wheel, kind_of: String, default: '512')
      attribute(:hbase_workers_size, kind_of: String)
      attribute(:hbase_zookeeper_getroot_retry_delay, kind_of: String, default: '1000')
      attribute(:hbase_zookeeper_quorum, kind_of: String, default: 'localhost')
      attribute(:hbase_zookeeper_session_timeout, kind_of: String, default: '5000')
      attribute(:hbase_zookeeper_znode_parent, kind_of: String, default: '/hbase')

      # Logback Parameters
      attribute(:logback_configfile, kind_of: String, default: '/etc/opentsdb/opentsdb_logback.xml')
      attribute(:logback_stdout_pattern, kind_of: String, default: '%d{ISO8601} %-5level [%thread] %logger{0}: %msg%n')
      attribute(:logback_cyclic_maxsize, kind_of: Integer, default: 1024)
      attribute(:logback_file, kind_of: String, default: '/var/log/opentsdb/opentsdb.log')
      attribute(:logback_file_append, kind_of: String, default: 'true')
      attribute(:logback_file_minindex, kind_of: Integer, default: 1)
      attribute(:logback_file_maxindex, kind_of: Integer, default: 3)
      attribute(:logback_file_maxfilesize, kind_of: String, default: '128MB')
      attribute(:logback_file_pattern, kind_of: String, default: '%d{HH:mm:ss.SSS} %-5level [%logger{0}.%M] - %msg%n')
      attribute(:logback_level, kind_of: String, default: 'INFO')
      attribute(:logback_stdout_flag, kind_of: [TrueClass, FalseClass], default: false)

      # Rollup Parameters
      attribute(:rollups_enable, kind_of: [TrueClass, FalseClass])
      attribute(:rollups_tag_raw, kind_of: [TrueClass, FalseClass])
      attribute(:rollups_agg_tag_key, kind_of: String)
      attribute(:rollups_raw_agg_tag_value, kind_of: String)
      attribute(:rollups_block_derived, kind_of: [TrueClass, FalseClass])

      attribute(:custom_plugin_options, kind_of: Hash)

      # JVM Arg Option
      attribute(:jvm_args, kind_of: [NilClass, String], default: nil)

      # JMX Options
      attribute(:jmx_port, kind_of: Integer, default: 10_201)
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
          # Create user
          poise_service_user new_resource.user
          # Install Packages
          prereq_pack
          remote_file "#{new_resource.instance} :create opentsdb-#{new_resource.version}#{distro_ext}" do
            path "/tmp/opentsdb-#{new_resource.version}#{distro_ext}"
            if new_resource.package_url
              source "#{new_resource.package_url}/opentsdb-#{new_resource.version}#{distro_ext}"
            else
              source "https://github.com/OpenTSDB/opentsdb/releases/download/v#{new_resource.version}/opentsdb-#{new_resource.version}#{distro_ext}"
            end
            action :create
          end

          package "opentsdb-#{new_resource.version}#{distro_ext}" do
            source "/tmp/opentsdb-#{new_resource.version}#{distro_ext}"
            if source.end_with?('.deb')
              provider Chef::Provider::Package::Dpkg
            elsif source.end_with?('.rpm')
              provider Chef::Provider::Package::Rpm
            end
            action :upgrade
          end

          # Ensure opentsdb confir dir is created
          directory new_resource.config_dir do
            owner new_resource.user
            group new_resource.group
            action :create
          end

          # Create opentsdb config and logback file
          {
            "#{new_resource.instance}.conf" => 'opentsdb.conf.erb',
            "#{new_resource.instance}_logback.xml" => 'logback.xml.erb'
          }.each_pair do |new_file, template_file|
            template "#{new_resource.instance} :create #{new_resource.config_dir}/#{new_file}" do
              source "#{new_resource.source_dir}/#{template_file}"
              path "#{new_resource.config_dir}/#{new_file}"
              variables(config: new_resource)
              owner new_resource.user
              group new_resource.group
              cookbook new_resource.cookbook
              notifies :restart, new_resource, :delayed
              mode '0644'
            end
          end
        end
        super
      end

      def service_options(service)
        platform_family = node.attribute?('platform_family') ? node['platform_family'] : node['platform_version']

        sys_init = \
          case node['platform']
          when 'debian'
            node['platform_version'].to_i >= 8 ? 'systemd' : 'sysvinit'
          when 'ubuntu'
            node['platform_version'].to_i >= 16 ? 'systemd' : 'sysvinit'
          when 'centos', 'redhat'
            node['platform_version'].to_i >= 7 ? 'systemd' : 'sysvinit'
          else
            'sysvinit'
          end

        template = \
          case sys_init
          when 'systemd'
            'opentsdb:etc/systemd/opentsdb.service.erb'
          when 'sysvinit'
            "opentsdb:etc/init.d/opentsdb_#{platform_family}.erb"
          else
            "opentsdb:etc/init.d/opentsdb_#{platform_family}.erb"
          end

        service.service_name(new_resource.instance)
        service.user new_resource.user
        service.command('/usr/share/opentsdb/bin/tsdb')
        service.provider sys_init
        service.options opentsdb_resource: new_resource, java_home: new_resource.java_home
        service.options sys_init, template: template
      end
    end
  end
end
