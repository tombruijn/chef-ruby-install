include RubyInstall::OptionsHelper
include RubyInstall::UsersHelper

action :install do
  install_ruby "no-reinstall" => nil
end

action :reinstall do
  install_ruby
end

private

def install_ruby(options = {})
  # Register action options for ruby-install
  options.each { |k,v| install_options[k] = v }

  # Register ruby-install options
  ruby_install_options = %w(install-dir src-dir patch mirror url md5 sha1
    sha256 sha512 no-download no-verify no-install-deps)
  ruby_install_options.each do |option|
    register_user_option(option)
  end

  # Apply user install defaults
  if new_resource.user
    unless install_options["src-dir"]
      # $HOME/rubies-src
      install_options["src-dir"] = ::File.join(user_home_dir, "rubies-src")
    end

    unless install_options["install-dir"]
      # $HOME/.rubies/{ruby_string}
      install_options["install-dir"] =
        ::File.join(user_home_dir, ".rubies", ruby_string)
    end
  end

  # Apply system install defaults
  unless install_options["install-dir"]
    # /opt/rubies/{ruby_string}
    install_options["install-dir"] = ::File.join("/opt", "rubies", ruby_string)
  end

  # Install Ruby
  stringified_install_options = stringify_install_options
  execute "ruby-install[#{new_resource.ruby}]" do
    command <<-EOH
      /usr/local/bin/ruby-install #{new_resource.ruby} \
        #{stringified_install_options}
    EOH
    user new_resource.user if new_resource.user
    group new_resource.group if new_resource.group
    environment new_resource.environment if new_resource.environment

    action :nothing
  end.run_action(:run)

  # Install gems
  if new_resource.gems
    new_resource.gems.each do |gem_config|
      gem_path = ::File.join(install_options["install-dir"], "bin/gem")
      gem_config = gem_config.dup # So we can delete entries from hash

      gem_package gem_config.delete(:name) do
        gem_binary gem_path
        version gem_config.delete(:version)
      end
    end
  end
end
