module RubyInstall
  module OptionsHelper
    attr_accessor :new_resource

    # Returns install options hash for Ruby installs.
    #
    # @return [Hash] install options.
    def install_options
      @install_options ||= {}
    end

    # Registers a user option as an install option if its value if not nil.
    #
    # @param options [String] option name.
    def register_user_option(option)
      option_name = option.gsub("-", "_")
      if new_resource.respond_to?(option_name)
        value = new_resource.send(option_name)
        install_options[option] = value if value
      end
    end

    # @return [String] string of all configured ruby-install options.
    def stringify_install_options
      options = install_options.map do |option, value|
        option_string = "--#{option}"
        option_string << " #{value}" unless value === true
        option_string
      end
      options.join(" ")
    end

    # @return [String] path friendly name for the Ruby installation.
    def ruby_string
      new_resource.ruby.gsub(" ", "-")
    end
  end
end
