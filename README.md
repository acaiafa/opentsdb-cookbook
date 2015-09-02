# OpenTSDB Cookbook
[![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

[Application cookbook][0] which installs and configures [OpenTSDB][1]. You will need to bring your own java cookbook to the party. I don't think its heplful for me to provide some random java cookbook from the internet. It will grab the version of the package from OpenTSDB github where they package all of the code into rpm or deb's. For RHEL it requires gnuplot so that gets installed. However please remember you must bring your own java cookbook or install method. Otherwise it will fail. Here is a quick example of installing java 8 if you need it [Java 8 Install][7].

## Usage
### Supports
- Ubuntu
- CentOS

### Dependencies
| Name | Description |
|------|-------------|
| [poise][4] | [Library cookbook][6] built to aide in writing reusable cookbooks. |
| [poise-service][5] | [Library cookbook][6] built to abstract service management. |

### Attributes
The current attributes are all set with the TSDB defaults that are listed here [OpenTSDB Default Options][2]. You can see how they are used/called here [OpenTSDB Library][3]

### Resources/Providers

#### opentsdb_instance
A default OpenTSDB instance as is easy as below

```ruby
opentsdb_instance "test"
```

You Can tune and tweak as you please
```ruby
opentsdb_instance "test" do
  bind '127.0.0.1'
  port 5012
  core_auto_create_metrics true
  search_enable true
end
```

As always you can also bring your own config file if you wanted to by calling the source resource. I have provided the default logback.xml file that is provided with the package.
License & Authors
-----------------
- Author:: Anthony Caiafa (<acaiafa1@bloomberg.net>)

```text
Copyright 2015 Bloomberg Finance L.P.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[0]: http://blog.vialstudios.com/the-environment-cookbook-pattern#theapplicationcookbook
[1]: http://opentsdb.net/
[2]: http://opentsdb.net/docs/build/html/user_guide/configuration.html
[3]: libraries/opentsdb_instance.rb
[4]: https://github.com/poise/poise
[5]: https://github.com/poise/poise-service
[6]: http://blog.vialstudios.com/the-environment-cookbook-pattern#thelibrarycookbook
[7]: https://github.com/johnbellone/java-service-cookbook/blob/master/recipes/default.rb
