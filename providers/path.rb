action :update do
  ruby_path = new_resource.path
  if new_resource.user && new_resource.group
    home_dir = "/home/#{new_resource.user}"

    # TODO: Add support for zsh
    profile_file = "#{home_dir}/.bashrc"
    source_command = "source #{home_dir}/.ruby_path"

    # Add path file to bash profile_file
    execute "Add Ruby path config" do
      command <<-EOH
        echo >> #{profile_file};
        echo >> #{profile_file};
        echo #{source_command} >> #{profile_file};
      EOH
      user new_resource.user
      group new_resource.group

      action :run
      only_if { `grep "#{source_command}" #{profile_file}` == "" }
    end

    # Write to path file
    file "#{home_dir}/.ruby_path" do
      content "export PATH=#{ruby_path}/bin:$PATH"

      user new_resource.user
      group new_resource.group
    end
  else
    Chef::Log.warn "Did not specify user for which to update Ruby path. "\
      "Skipping..."
  end
end
