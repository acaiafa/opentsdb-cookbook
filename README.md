# OpenTSDB Cookbook
[![Build Status](https://img.shields.io/travis/acaiafa/opentsdb-cookbook.svg)](https://travis-ci.org/acaiafa/opentsdb-cookbook)
[![Code Quality](https://img.shields.io/codeclimate/github/acaiafa/opentsdb-cookbook.svg)](https://codeclimate.com/github/acaiafa/opentsdb-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/opentsdb.svg)](https://supermarket.chef.io/cookbooks/opentsdb)
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

[Application cookbook][0] which installs and configures [OpenTSDB][1].

## Basic Usage
A default instance of OpenTSDB can easily be created using the
[opentsdb_instance resource](libraries/opentsdb_instance).
``` ruby
opentsdb_instance 'test'
```

## Advanced Usage
You Can tune and tweak as you please.
```
opentsdb_instance "test" do
  bind '127.0.0.1'
  port 5012
  core_auto_create_metrics true
  search_enable true
end
```

You will need to bring your own java cookbook to the party. I don't think its heplful for me to provide some random java cookbook from the internet. It will grab the version of the package from OpenTSDB github where they package all of the code into rpm or deb's. For RHEL it requires gnuplot so that gets installed. However please remember you must bring your own java cookbook or install method. Otherwise it will fail. Here is a quick example of installing java 8 if you need it [Java 8 Install][7].





[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern#theapplicationcookbook
[1]: http://opentsdb.net/
[2]: http://opentsdb.net/docs/build/html/user_guide/configuration.html
[3]: libraries/opentsdb_instance.rb
[4]: https://github.com/poise/poise
[5]: https://github.com/poise/poise-service
[6]: http://blog.vialstudios.com/the-environment-cookbook-pattern#thelibrarycookbook
[7]: https://github.com/johnbellone/java-service-cookbook/blob/master/recipes/default.rb
