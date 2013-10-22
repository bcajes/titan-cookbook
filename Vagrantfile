Vagrant.configure("2") do |config|
  config.vm.box = "precise64"
  config.omnibus.chef_version = :latest
  config.vm.graceful_halt_retry_interval = 3
  config.berkshelf.enabled = true

  config.vm.define :es1 do |es1|
    es1.vm.network :private_network, ip: "33.33.33.29"
    es1.vm.hostname = "es1"
    es1.vm.provision :chef_solo do |chef|
      #make sure titan can connect to ES via the below network host
      chef.json = {
        "elasticsearch" => {
          "network" => { "host" => "33.33.33.29"},
          :cluster => { :name => "elasticsearch_vagrant" },

          :plugins => {
            'karmi/elasticsearch-paramedic' => {}
          },
          
          :limits => {
            :nofile  => 1024,
            :memlock => 512
          },
          :bootstrap => {
            :mlockall => false
          },
          
          :logging => {
            :discovery => 'TRACE',
            'index.indexing.slowlog' => 'INFO, index_indexing_slow_log_file'
          },
          
          :nginx => {
            :user  =>  'www-data',
            :users => [{ username: 'USERNAME', password: 'PASSWORD' }]
          },
          # For testing flat attributes:
          "index.search.slowlog.threshold.query.trace" => "1ms",
          # For testing deep attributes:
          :discovery => { :zen => { :ping => { :timeout => "9s" } } },
          # For testing custom configuration
          :custom_config => {
            'threadpool.index.type' => 'fixed',
            'threadpool.index.size' => '2'
          }
        },
	"java" => {"oracle" => {
            "accept_oracle_download_terms" => true}
        }
      }
      chef.add_recipe "apt"
      chef.add_recipe "java::oracle"
      chef.add_recipe "nginx"
      chef.add_recipe "elasticsearch"
      chef.add_recipe "elasticsearch::proxy"
      chef.add_recipe "elasticsearch::data"
    end
  end

  config.vm.define :titan1 do |titan1|
    titan1.vm.network :private_network, ip: "33.33.33.28"
    titan1.vm.network :forwarded_port, guest: 8182, host: 8182		
    titan1.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 2048]
    end
    titan1.vm.hostname = "titan1"		 
    titan1.vm.provision :chef_solo do |chef|
      chef.add_recipe "titan"
    end
  end
end
