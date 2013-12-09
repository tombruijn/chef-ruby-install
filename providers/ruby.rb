action :install do
  install_ruby "no-reinstall" => nil
end

action :reinstall do
  install_ruby
end

private

def install_ruby(options = {})
  install_options = options.map { |k,v| "--#{k} #{v}" }
  ruby_string = new_resource.ruby.gsub(" ", "-")

  if new_resource.rubies_path
    ruby_path = ::File.join(new_resource.rubies_path, ruby_string)
    install_options << "--install-dir #{ruby_path}"
  else
    ruby_path = ::File.join("/opt", "rubies", ruby_string)
  end

  execute "ruby-install[#{new_resource.ruby}]" do
    command <<-EOH
      /usr/local/bin/ruby-install #{new_resource.ruby} \
        #{install_options.join(" ")}
    EOH
    user new_resource.user if new_resource.user
    group new_resource.group if new_resource.group
    environment new_resource.environment if new_resource.environment

    action :nothing
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
