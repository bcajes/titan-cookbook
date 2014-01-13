#Titan 0.4+ runs on java 7
default['java']['install_flavor'] = "oracle"
default['java']['jdk_version'] = '7'
default['java']['oracle']['accept_oracle_download_terms'] = true

#titan attributes
default[:titan] = {
  :installation_dir => "/opt/titan/",
  :version => "0.4.2",  
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
  :db_cache => true,
  :db_cache_clean_wait => 0,
  :db_cache_time => 0,
  :db_cache_size => 0.25,
  :index_directory => File.join("#{node.titan.installation_dir}","db/es"),
  :index_client_only => false, #Whether this node is client node with no data. https://github.com/thinkaurelius/titan/wiki/Using-Elastic-Search
  :index_local_mode => true,
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
  :script_engines => [
                      #  TODO 
                      #{:name => 'gremlin-groovy', :reset_threshold => -1, :imports => ['com.company.ext_package.*'] }
                     ]

# TODO metrics block
# TODO graphs block
  
}

default[:titan][:ext_pkgs] = [
                              #{:file_name => ext_pkg.jar, :uri => ftp://user:pw@example.com/ext/ext_pkg.jar}
                             ]

default[:titan][:download_url] = "http://s3.thinkaurelius.com/downloads/titan/titan-server-#{default[:titan][:version]}.zip"




