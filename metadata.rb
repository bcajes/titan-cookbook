name             "titan"
maintainer       "Brian Cajes"
maintainer_email "brian.cajes@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures Titan with Cassandra storage backend and ElasticSearch index backend"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.2"

depends "apt"
depends "cassandra"
