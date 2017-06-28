# helpers for opentsdb

module OpentsdbCookbook
  module Helpers
    include Chef::DSL::IncludeRecipe

    def distro_ext
      platform_family = node.attribute?('platform_family') ? node['platform_family'] : node['platform_version']
      case platform_family
      when 'debian'
        '_all.deb'
      when 'rhel'
        '.noarch.rpm'
      end
    end

    def prereq_pack
      # RHEL world neds gnuplot
      platform_family = node.attribute?('platform_family') ? node['platform_family'] : node['platform_version']
      if platform_family.eql?('rhel')
        package 'gnuplot' do
          action :install
        end
      end
    end
  end
end
