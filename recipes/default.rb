include_recipe "git"

attributes = node["ruby-install"]
git_url = attributes["git_url"]
git_ref = attributes["git_ref"]

install_path = attributes["install_path"]
unless install_path
  cache_path = Chef::Config["file_cache_path"]
  install_path = "#{cache_path}/ruby-install"
end

directory install_path do
  recursive true
  action :create
end

execute "Install ruby-install" do
  cwd install_path
  command %{sudo make install}

  action :nothing
end

git install_path do
  repository git_url
  reference git_ref

  action :sync

  notifies :run, resources(execute: "Install ruby-install"), :immediately
end
