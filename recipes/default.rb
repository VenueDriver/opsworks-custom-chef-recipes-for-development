Chef::Log.level = :debug
Chef::Log.info("********** Setting up development desktop instance **********")

execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end

package "Install development stuff" do
  package_name %w(build-essential git nodejs ruby-full docker.io)
end
