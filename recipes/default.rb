include_recipe "java"


# 1. Download the Zip to /tmp
require "tmpdir"

group node[:titan][:group] do
  action :create
end

user node[:titan][:user] do
  gid node[:titan][:group]
  home node[:titan][:installation_dir]
end


td          = Dir.tmpdir
tmp         = File.join(td, "titan-server-#{node.titan.version}.zip")
zip_dir = File.join(td, "titan-server-#{node.titan.version}")

remote_file(tmp) do
  source node.titan.download_url
  action :create_if_missing
  owner node["titan"]["user"]
  group node["titan"]["group"]
end


directory "#{node.titan.installation_dir}" do
  owner node["titan"]["user"]
  group node["titan"]["group"]
  mode node["titan"]["install_dir_permissions"]
  recursive true
end


# 2. Extract it
# 3. Copy to install dir, update permissions
package "unzip"
bash "extract #{tmp}, move it to #{node.titan.installation_dir}" do
  user "#{node.titan.user}"
  group "#{node.titan.group}"
  cwd  "/tmp"

  code <<-EOS
    unzip -o #{tmp}
    mkdir -p $(dirname #{node.titan.installation_dir}) 
    mv --force #{zip_dir}/* #{node.titan.installation_dir}
    rmdir #{zip_dir}
  EOS

  creates "#{node.titan.installation_dir}/bin/titan.sh"
end

#create cassandra configuration
if node[:titan][:manage_cassandra_config]
  template node["titan"]["storage"]["cassandra_config"] do
    source "cassandra.yaml.erb"
    owner node["titan"]["user"]
    group node["titan"]["group"]
    mode  node["titan"]["install_dir_permissions"]
    variables(
      :broadcast_address => node["titan"]["cassandra"]["broadcast_address"],
      :concurrent_reads => node["titan"]["cassandra"]["concurrent_reads"],
      :concurrent_writes => node["titan"]["cassandra"]["concurrent_writes"],
      :cluster_name => node["titan"]["cassandra"]["cluster_name"], 
      :initial_token => node["titan"]["cassandra"]["initial_token"],
      :listen_address => node["titan"]["cassandra"]["listen_address"],
      :rpc_address => node["titan"]["cassandra"]["rpc_address"],
      :seeds => node["titan"]["cassandra"]["seeds"]
    )
  end
end
  
#create properties file
template node["titan"]["storage"]["properties"] do
    source "titan-server-cassandra-es.properties.erb"
    owner node["titan"]["user"]
    group node["titan"]["group"]
    mode  node["titan"]["install_dir_permissions"]
  end

#create rexster server conf
template node["titan"]["rexster"]["config"] do
    source "rexster-cassandra-es.xml.erb"
    owner node["titan"]["user"]
    group node["titan"]["group"]
    mode  node["titan"]["install_dir_permissions"]
  end

#handle external dependencies/jars
include_recipe "titan::ext"

#setup upstart script
template "/etc/init/titan.conf" do
  source "titan.upstart.conf.erb"
  owner "root"
  group "root"
  mode "0644"
end

service "titan" do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :status => true, :stop => true
  action [:start]
end
