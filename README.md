# OpenTSDB Cookbook
[![Build Status](https://img.shields.io/travis/acaiafa/opentsdb-cookbook.svg)](https://travis-ci.org/acaiafa/opentsdb-cookbook)
[![Code Quality](https://img.shields.io/codeclimate/github/acaiafa/opentsdb-cookbook.svg)](https://codeclimate.com/github/acaiafa/opentsdb-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/opentsdb.svg)](https://supermarket.chef.io/cookbooks/opentsdb)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

[Application cookbook][0] which installs and configures [OpenTSDB][1].

This cookbook provides a dead-simple installation and configuration of
OpenTSDB. It provides a single resource for
[an instance of tsdb](libraries/opentsdb_instance.rb). The default recipe
will quickly get you started.

## Basic Usage
The [default recipe](recipes/default.rb) installs Java 8 and
configures OpenTSDB on a node using the
[opentsdb_instance resource](libraries/opentsdb_instance.rb).below.

## Advanced Usage
For a more granular configuration
[take a look at the resource](libraries/opentsdb_instance.rb).
```ruby
opentsdb_instance "test" do
  bind '127.0.0.1'
  port 5012
  core_auto_create_metrics true
  search_enable true
end
```

[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern#theapplicationcookbook
[1]: http://opentsdb.net/
[2]: http://opentsdb.net/docs/build/html/user_guide/configuration.html
