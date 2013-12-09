include_recipe "ruby-install::default"

attributes = node["ruby-install"]
rubies = attributes["rubies"]

rubies.each do |config|
  ruby = config["ruby"]
  ruby_install_ruby "#{ruby["implementation"]}-#{ruby["version"]}" do
    ruby_implementation ruby["implementation"]
    ruby_version ruby["version"]
    rubies_path attributes["rubies_path"]
    update_path config["update_path"]
    user config["user"]
    group config["group"]
    gems config["gems"]

    if config["reinstall"]
      action :reinstall
    else
      action :install
    end
  end
end
