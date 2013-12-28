module RubyInstall
  module UsersHelper
    # @return [String] home dir of the configured user.
    def user_home_dir
      Dir::home(new_resource.user)
    end
  end
end
