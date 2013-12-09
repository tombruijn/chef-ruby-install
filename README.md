# ruby-install Chef cookbook

Installs postmodern's [ruby-install](https://github.com/postmodern/ruby-install)
and optionally Ruby versions.
It also offers to add Ruby to your path.

## Dependencies

- git

## Recipes

### ruby-install::default

This default recipe will install ruby-install.
Using the `git_url` attribute it will download a Git repository

### ruby-install::install

This recipe will also use ruby-install to install rubies.
One or more can be specified using the attributes.

The same can be accomplished by using the `ruby_install_ruby` provider
(which this recipe uses).

_Personally I recommend using the `ruby_install_ruby` and `ruby_install_path`
resources to accomplish this._

## Attributes

All attributes are scoped within the `ruby-build` node attribute.
See also example below.

- `git_url` - String - Default: `https://github.com/postmodern/ruby-install.git`
- `git_ref` - String - Default: `v0.3.2`
- `install_path` - String - Defaults to: "/var/chef/cache/ruby-install"  
  (_Uses the `file_cache_path` attribute from Chef's config._)
- `rubies_path` - String - Defaults to: ruby-install's default.
  Currently: `/opt/rubies`
- `rubies` - Array - Default: []  
  Each array element is a Hash with the following attributes:
  - `ruby` - String - ruby-install specific Ruby version selector.  
     Examples: `ruby`, `ruby 2.0.0-p353` or `rubinius stable`.  
     _Keywords such as stable are not supported by update_path._
  - `user` - String - User for which to install the Ruby version.
  - `group` - String - Group for which to install the Ruby version.
  - `reinstall` - Boolean - Default: false - Set to true to reinstall the ruby.
  - `update_path` - Boolean - Default: `false`  
    Set to true to set the Ruby version to path.
    Requires the `user` attribute to be set.
  - `gems` - Array - Default: `[]`  
    Each array element is a Hash with the following attributes:
    - `name` - Name of the gem to install.
    - `version` - Version of the gem to install.
    - And any other gem install options. Use their `--` variant.

Example:

```
{
  "ruby-install" => {
    git_url: "https://github.com/postmodern/ruby-install.git",
    git_ref: "v0.3.2",
    install_path: "/home/vagrant/ruby-install",
    rubies_path: "/home/vagrant/.rubies",
    rubies: [
      {
        ruby: "ruby 2.0.0-p247",
        user: "vagrant",
        group: "vagrant",
        reinstall: true,
        update_path: true,
        gems: [
          { name: "bundler", version: "1.3.5" }
        ]
      }
    ]
  }
}
```

## Resources and Providers

### ruby_install_ruby

This provider installs rubies using ruby-install.

#### Actions

##### Install

Installs the Ruby specified using ruby-install.

##### Reinstall

Tells ruby-install to reinstall the ruby.

#### Attributes

- `ruby` - String - ruby-install specific Ruby version selector.  
  Examples: `ruby`, `ruby 2.0.0-p353` or `rubinius 2.1.1`.  
  _Keywords such as stable are not yet supported._
- `rubies_path` - String - Path to install the rubies to.
  Defaults to: ruby-install's default. Currently: `/opt/rubies`
- `update_path` - Boolean - Default: `false`  
   Set to true to set the Ruby version to path.
   Requires the `user` attribute to be set.
- `user` - String - User for which to install the Ruby version.
- `group` - String - Group for which to install the Ruby version.
- `environment` - Hash - environment variables to be set.

### ruby_install_path

This provider updates the path to the specified Ruby version.

#### Actions

##### Update

Updates path to specified Ruby version.

#### Attributes

- `ruby_path` - String - Path to Ruby install.
- `user` - String - User for which to update the path.
- `group` - String - Group for which to update the path.

## License

This cookbook is released under the MIT License.
See the bundled LICENSE file for details.
