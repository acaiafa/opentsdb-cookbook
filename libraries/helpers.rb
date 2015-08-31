# helpers for opentsdb

module OpentsdbCookbook
  module Helpers
    include Chef::DSL::IncludeRecipe

    def distro_ext
      case node.platform_family
      when 'debian'
        '_all.deb'
      when 'rhel'
        '.noarch.rpm'
      end
    end
  end
end
