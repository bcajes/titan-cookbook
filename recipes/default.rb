include_recipe "cassandra::tarball"


# 1. Download the Zip to /tmp
require "tmpdir"

td          = Dir.tmpdir
tmp         = File.join(td, "titan-all-#{node.titan.version}.zip")
zip_dir = File.join(td, "titan-all-#{node.titan.version}")

remote_file(tmp) do
  source node.titan.download_url

  not_if {File.exists?("#{tmp}")}
end

# 2. Extract it
# 3. Copy to /usr/local/titan, update permissions
package "unzip"
bash "extract #{tmp}, move it to #{node.titan.installation_dir}" do
  user node.titan.user
  cwd  "/tmp"

  code <<-EOS
    rm -rf #{node.titan.installation_dir}
    unzip #{tmp}
    mv --force #{zip_dir} #{node.titan.installation_dir}
  EOS

  creates "#{node.titan.installation_dir}/bin/titan.sh"
end

#create properties file
template File.join(node["titan"]["conf_dir"], node["titan"]["properties_file_name"]) do
    source "titan-server-cassandra-es.properties.erb"
    owner node["titan"]["user"]
    group node["titan"]["user"]
    mode  0644
  end


# 6. init.d Service                                                                              
template "/etc/init.d/titan" do
  source "titan.init.erb"
  owner 'root'
  mode  0755
end

#stop existing cassandra service, so that we can bring it up with titan
service "cassandra" do 
  action :stop
end

#xxx fix service stop
service "titan" do
  supports :start => true, :stop => false, :restart => true
  action [:enable, :start]
end
