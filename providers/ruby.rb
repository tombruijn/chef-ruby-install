action :install do
  install_options = []
  ruby_implementation = new_resource.ruby_implementation
  ruby_version = new_resource.ruby_version
  ruby_string = ruby_version_string(ruby_implementation, ruby_version)

  if new_resource.rubies_path
    ruby_path = ::File.join(new_resource.rubies_path, ruby_string)
    install_options << "--install-dir #{ruby_path}"
  else
    ruby_path = ::File.join("/opt", "rubies", ruby_string)
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

  if new_resource.gems
    new_resource.gems.each do |gem_config|
      gem_options = []
      gem_config.select{|k,v| k != "name" }.each do |key, value|
        gem_options << "--#{key} #{value}"
      end

      execute "gem install #{gem_config["name"]}" do
        command "gem install #{gem_config["name"]} #{gem_options.join(" ")}"
      end
    end
  end

  if new_resource.update_path
    ruby_install_path ruby_path do
      user new_resource.user if new_resource.user
      group new_resource.group if new_resource.group
    end
  end
end

private

def ruby_version_string(impl, version)
  "#{impl}-#{version}"
end
