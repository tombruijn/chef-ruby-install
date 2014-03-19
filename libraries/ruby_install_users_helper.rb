module RubyInstall
  module UsersHelper
    attr_accessor :new_resource

    # @return [String] home dir of the configured user.
    def user_home_dir
      Dir::home(new_resource.user)
    end
  end
end
