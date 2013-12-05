action :install do
  ruby_implementation = new_resource.ruby_implementation
  ruby_version = new_resource.ruby_version
  rubies_path = new_resource.rubies_path
  ruby_path = ::File.join(rubies_path, ruby_version_string(ruby_implementation, ruby_version))

  execute "ruby-install[#{ruby_version_string ruby_implementation, ruby_version}]" do
    command <<-EOH
      /usr/local/bin/ruby-install #{ruby_implementation} #{ruby_version} \
        --install-dir #{ruby_path}
    EOH
    user new_resource.user if new_resource.user
    group new_resource.group if new_resource.group
    environment new_resource.environment if new_resource.environment

    action :run
    not_if { ::File.exists?(ruby_path) }
  end

  home_dir = nil
  home_dir = "/home/#{new_resource.user}/" if new_resource.user

  if new_resource.update_path
    source_command = "source $HOME/.ruby_path"
    execute "Add ruby path config" do
      # TODO: Add support for zsh
      command <<-EOH
        echo >> $HOME/.bashrc;
        echo >> $HOME/.bashrc;
        echo #{source_command} >> $HOME/.bashrc;
      EOH
      cwd home_dir if home_dir
      user new_resource.user if new_resource.user
      group new_resource.group if new_resource.group

      action :run
      only_if { `grep "#{source_command}" $HOME/.bashrc` == "" }
    end
  end

  if new_resource.default
    default_ruby_path = "export PATH=#{ruby_path}/bin:$PATH"
    file "#{home_dir}.ruby_path" do
      content default_ruby_path

      user new_resource.user if new_resource.user
      group new_resource.group if new_resource.group

      not_if { `cat .ruby_path` == default_ruby_path }
    end
  end
end

private

def ruby_version_string(impl, version)
  "#{impl}-#{version}"
end
