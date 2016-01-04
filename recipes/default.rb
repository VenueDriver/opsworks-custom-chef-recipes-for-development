Chef::Log.level = :debug
Chef::Log.info("********** Setting up development desktop instance **********")

execute "Add GPG key for Docker installation" do
  user "ubuntu"
  cwd "/home/ubuntu"
  command %{sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D}
end

template '/etc/apt/sources.list.d/docker.list' do
  source 'docker.list'
  owner 'root'
  group 'root'
  mode '644'
end

execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
end

bash "Install linux-image-extra for specific OS release" do
  command "sudo apt-get install linux-image-extra-$(uname -r)"
  ignore_failure true
end

package "Install basic development stuff" do
  package_name %w(build-essential git nodejs ruby-full)
end

package "Install Docker engine" do
  package_name %w(docker-engine)
end
