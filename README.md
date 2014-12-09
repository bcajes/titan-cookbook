# Titan graph DB Chef Cookbook

Installs Titan Server (0.5.0 +) embedded with cassandra + elasticsearch as index backend

## Tested OS Distributions

Ubuntu 12.04.


## Recipes

Default: Install Titan Server embedded with cassandra and elastic search index backend. See attributes for configuration options. 

If you want to install a multi-node install of titan, you will need to set the `node[:titan][:cassandra]` attributes. 

## Dependencies

Cookbook dependecies managed by Berkshelf (see Berskfile)

##Vagrant test node usage

1. Install [Vagrant](http://www.vagrantup.com/)
2. Install [Berkshelf](http://berkshelf.com/)
3. Add vm image to vagrant: cookbook_root$  vagrant box add precise64 http://files.vagrantup.com/precise64.box
4. cookbook_root$ vagrant plugin install vagrant-omnibus
5. cookbook_root$ vagrant plugin install vagrant-berkshelf
6. cookbook_root$ berks install
7. cookbook_root$ vagrant up --provision
8. cookbook_root$ curl http://33.33.33.28:8182/graphs/



##TODO
1. Fleshout documentation
2. Add support for more titan options
3. Add support for HBASE

## Copyright & License

Brian Cajes, 2014

Released under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).
