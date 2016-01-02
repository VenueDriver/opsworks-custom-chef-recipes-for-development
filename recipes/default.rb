Chef::Log.level = :debug
Chef::Log.info("********** Setting up development desktop instance **********")

execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end

package "Install Ubuntu Desktop" do
  package_name "ubuntu-desktop"
end

package "Install GNOME stuff" do
  package_name %w(gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal)
end

package "Install VNC" do
  package_name "tightvncserver"
end

execute "Set VNC password" do
  user "ubuntu"
  cwd "/home/ubuntu"
  command %{mkdir .vnc; echo "password" | vncpasswd -f > .vnc/passwd; chmod 600 .vnc/passwd; sudo chgrp ubuntu .vnc/passwd}
end

template '/home/ubuntu/.vnc/xstartup' do
  source 'xstartup'
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
end

template '/etc/init.d/vncserver' do
  source 'vncserver'
  owner 'root'
  group 'root'
  mode '0755'
end
execute "Auto-start VNC" do
  user "ubuntu"
  command %{sudo update-rc.d vncserver defaults}
end

package "Install development stuff" do
  package_name %w(build-essential git nodejs virtualbox vagrant ruby-full)
end
