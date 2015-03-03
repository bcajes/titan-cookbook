# recipe to download and install external jar packages to be used by rexster
# https://github.com/tinkerpop/rexster/wiki/Rexster-Configuration

node['titan']['ext_pkgs'].each do |pkg|
  log "installing titan/ext package #{pkg.file_name} from #{pkg.uri}"
  remote_file("#{node['titan']['installation_dir']}/ext/#{pkg.file_name}") do
    source pkg.uri
  end
end
