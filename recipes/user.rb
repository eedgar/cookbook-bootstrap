# This gem is required for the user resource to use passwords
chef_gem 'ruby-shadow'

# Some handy vars
user_home = "/home/#{node['bootstrap']['user']}"
user_gemrc = "#{user_home}/.gemrc"
user_bashrc = "#{user_home}/.bashrc"

# Create the aentos user
user node['bootstrap']['user'] do
  uid      node['bootstrap']['uid']
  gid      node['bootstrap']['gid']
  home     user_home
  shell    node['bootstrap']['shell']
  password node['bootstrap']['password']
  supports :manage_home => true
end

# Add the aentos user to the sudoers with NOPASSWD
sudo node['bootstrap']['user'] do
  user node['bootstrap']['user']
  commands [ "ALL" ]
  nopasswd true
end

# Create a .gemrc for the aentos user
file user_gemrc do
  content node['bootstrap']['gem_options']
  action :create_if_missing
end

# Add export DISPLAY=:0 to the .bashrc file if it doesn't have it yet
conf_plain_file user_bashrc do
  pattern   /export DISPLAY=:0/
  new_line  'export DISPLAY=:0'
  action :insert_if_no_match
end

# Add a custom PS1 var to a profile script (/etc/profile.d/*.sh)
file "/etc/profile.d/ps1.sh" do
  content node['bootstrap']['ps1']
end
