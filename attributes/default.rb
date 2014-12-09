#Titan 0.5+ runs on java 7
default['java']['jdk_version'] = '7'



#titan attributes
default[:titan] = {
  :installation_dir => "/opt/titan/",
  :version => "0.5.2-hadoop1",  
  :user => "titan", 
  :group => "titan",
  :install_dir_permissions => "755"
}

default[:titan][:conf_dir] = File.join("#{default[:titan][:installation_dir]}", "conf")
default[:titan][:start_command] = File.join("#{default[:titan][:installation_dir]}", "bin/titan.sh") + " -v -c cassandra-es start"
default[:titan][:stop_command] = File.join("#{default[:titan][:installation_dir]}", "bin/titan.sh") + " stop"


default[:titan][:storage] = {
  :properties => File.join("#{node.titan.conf_dir}","titan-server-cassandra-es.properties"),
  :cassandra_config => File.join("#{node.titan.conf_dir}","cassandra.yaml"),
  :storage_backend => "cassandra",
  :db_cache => true,
  :db_cache_clean_wait => 0,
  :db_cache_time => 0,
  :db_cache_size => 0.25,
  :index_backend => "elasticsearch",
  :index_directory => File.join("#{node.titan.installation_dir}","db/es"),
  :index_client_only => false, #Whether this node is client node with no data. https://github.com/thinkaurelius/titan/wiki/Using-Elastic-Search
  :index_local_mode => true,
  :index_hostname => "127.0.0.1" #hostname of ES if not running embedded
}

#reference: https://github.com/tinkerpop/rexster/wiki/Rexster-Configuration
default[:titan][:rexster] = {
  :config => File.join("#{node.titan.conf_dir}","rexster-cassandra-es.xml"),
  :http => {
    :server_port => 8182,
    :server_host => '0.0.0.0',
    :base_uri => 'http://localhost',
    :character_set => 'UTF-8',
    :enable_jmx => false,
    :enable_doghouse => true,
    :max_post_size => 2097152,
    :max_header_size => 8192,
    :upload_timeout_millis => 30000,
    :thread_pool => {
      :worker => { #upping sizes from default 8/8: https://github.com/tinkerpop/rexster/issues/271
        :core_size => 16,
        :max_size => 32
      },
      :kernal => {
        :core_size => 4,
        :max_size => 4
      }
    },
    :io_strategy => 'leader-follower'
  },
  :rexpro => {
    :server_port => 8184,
    :server_host => '0.0.0.0',
    :session_max_idle => 1790000,
    :session_check_interval => 3000000,
    :connection_max_idle => 180000,
    :connection_check_interval => 3000000,
    :enable_jmx => false,
    :thread_pool => {
      :worker => { #upping sizes from default 8/8: https://github.com/tinkerpop/rexster/issues/271
        :core_size => 16,
        :max_size => 32
      },
      :kernal => {
        :core_size => 4,
        :max_size => 4
      }
    },
    :io_strategy => 'leader-follower'
  },
  :security => {
    :authentication => {
      :type => 'none', #'default' basic auth
      :configuration => { #if type other than 'none' 
        :users => [{:username => 'rexster', #replace
                     :password => 'rexster' #replace
                   }
                  ]                   
      }
    }    
  },
  :shutdown_port => 8183,
  :shutdown_host => '127.0.0.1',
  :script_engines => { :init_scripts => nil,
    :imports => "com.tinkerpop.gremlin.*,com.tinkerpop.gremlin.java.*,com.tinkerpop.gremlin.pipes.filter.*,com.tinkerpop.gremlin.pipes.sideeffect.*,com.tinkerpop.gremlin.pipes.transform.*,com.tinkerpop.blueprints.*,com.tinkerpop.blueprints.impls.*,com.tinkerpop.blueprints.impls.tg.*,com.tinkerpop.blueprints.impls.neo4j.*,com.tinkerpop.blueprints.impls.neo4j.batch.*,com.tinkerpop.blueprints.impls.neo4j2.*,com.tinkerpop.blueprints.impls.neo4j2.batch.*,com.tinkerpop.blueprints.impls.orient.*,com.tinkerpop.blueprints.impls.orient.batch.*,com.tinkerpop.blueprints.impls.dex.*,com.tinkerpop.blueprints.impls.rexster.*,com.tinkerpop.blueprints.impls.sail.*,com.tinkerpop.blueprints.impls.sail.impls.*,com.tinkerpop.blueprints.util.*,com.tinkerpop.blueprints.util.io.*,com.tinkerpop.blueprints.util.io.gml.*,com.tinkerpop.blueprints.util.io.graphml.*,com.tinkerpop.blueprints.util.io.graphson.*,com.tinkerpop.blueprints.util.wrappers.*,com.tinkerpop.blueprints.util.wrappers.batch.*,com.tinkerpop.blueprints.util.wrappers.batch.cache.*,com.tinkerpop.blueprints.util.wrappers.event.*,com.tinkerpop.blueprints.util.wrappers.event.listener.*,com.tinkerpop.blueprints.util.wrappers.id.*,com.tinkerpop.blueprints.util.wrappers.partition.*,com.tinkerpop.blueprints.util.wrappers.readonly.*,com.tinkerpop.blueprints.oupls.sail.*,com.tinkerpop.blueprints.oupls.sail.pg.*,com.tinkerpop.blueprints.oupls.jung.*,com.tinkerpop.pipes.*,com.tinkerpop.pipes.branch.*,com.tinkerpop.pipes.filter.*,com.tinkerpop.pipes.sideeffect.*,com.tinkerpop.pipes.transform.*,com.tinkerpop.pipes.util.*,com.tinkerpop.pipes.util.iterators.*,com.tinkerpop.pipes.util.structures.*,org.apache.commons.configuration.*,com.thinkaurelius.titan.core.*,com.thinkaurelius.titan.core.attribute.*,com.thinkaurelius.titan.core.log.*,com.thinkaurelius.titan.core.olap.*,com.thinkaurelius.titan.core.schema.*,com.thinkaurelius.titan.core.util.*,com.thinkaurelius.titan.example.*,org.apache.commons.configuration.*,com.tinkerpop.gremlin.Tokens.T,com.tinkerpop.gremlin.groovy.*", 
    :static_imports => "com.tinkerpop.blueprints.Direction.*,com.tinkerpop.blueprints.TransactionalGraph$Conclusion.*,com.tinkerpop.blueprints.Compare.*,com.thinkaurelius.titan.core.attribute.Geo.*,com.thinkaurelius.titan.core.attribute.Text.*,com.tinkerpop.blueprints.Query$Compare.*"},
            

# TODO metrics block
# TODO graphs block
  
}

# set to false if you want to manage your own cassandra.yaml file,
# which is useful for more specialized configurations
default[:titan][:manage_cassandra_config] = true

# TODO add useful cassandra attributes

# see cassandra.yaml.erb for documentation on these options
default[:titan][:cassandra] = {
  :broadcast_address => '',
  :concurrent_reads => 32,
  :concurrent_writes => 32,
  :cluster_name => 'Titan Test Cluster',
  :initial_token => nil,
  :listen_address => 'localhost',
  :num_tokens => nil,
  :rpc_address => 'localhost',
  :seeds => '127.0.0.1'
}

default[:titan][:ext_pkgs] = [
                              #{:file_name => ext_pkg.jar, :uri => ftp://user:pw@example.com/ext/ext_pkg.jar}
                             ]

default[:titan][:download_url] = "http://s3.thinkaurelius.com/downloads/titan/titan-#{node[:titan][:version]}.zip"




