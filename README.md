# Titan graph DB Chef Cookbook

Installs Titan embedded within cassandra + connects to elastic search as index backend

## Tested OS Distributions

Ubuntu 12.04.


## Recipes

Install Titan. See attributes configuration options.


## Dependencies

Berkshelf (see Vagrantfile for vagrant dependencies)

##Vagrant test cluster usage

1. Install cookbook dependencies: berks install
2. vagrant up

Vagrant should launch a titan node and an elastic search node for you to test out.


##TODO
Add support for HBASE
Fleshout documentation
Add support for more titan options


## Copyright & License

Brian Cajes, 2013

Released under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).
