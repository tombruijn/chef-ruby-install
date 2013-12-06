action :install do
  install_options = []
  ruby_implementation = new_resource.ruby_implementation
  ruby_version = new_resource.ruby_version
  ruby_string = ruby_version_string(ruby_implementation, ruby_version)

  if new_resource.rubies_path
    ruby_path = ::File.join(new_resource.rubies_path, ruby_string)
    install_options << "--install-dir #{ruby_path}"
  else
    ruby_path = ::File.join("opt", "rubies", ruby_string)
  end

  execute "ruby-install[#{ruby_string}]" do
    command <<-EOH
      /usr/local/bin/ruby-install #{ruby_implementation} #{ruby_version} \
        #{install_options.join(" ")}
    EOH
    user new_resource.user if new_resource.user
    group new_resource.group if new_resource.group
    environment new_resource.environment if new_resource.environment

    action :nothing
    not_if { ::File.exists?(ruby_path) }
  end.run_action(:run)

  if new_resource.user && new_resource.group
    home_dir = "/home/#{new_resource.user}"

    if new_resource.update_path
      # TODO: Add support for zsh
      profile_file = "#{home_dir}/.bashrc"
      source_command = "source #{home_dir}/.ruby_path"

      # Add path file to bash file
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
    end
  else
    Chef::Log.warn "Did not specify user for which to update Ruby path. "\
      "Skipping..."
  end
end

private

def ruby_version_string(impl, version)
  "#{impl}-#{version}"
end
