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
  - `ruby` - Hash
    - `implementation` - String - Supported ruby-install implementations.  
      These include: `ruby`, `jruby`, `rubinius`, `maglev`.
    - `version` - String - The Ruby version you want to install.  
      Example: `2.0.0-p353`
  - `user` - String - User for which to install the Ruby version.
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
        ruby: { implementation: "ruby", version: "2.0.0-p247" },
        user: "vagrant",
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

#### Attributes

- `ruby_implementation` - String - Supported ruby-install implementations.  
   These include: `ruby`, `jruby`, `rubinius`, `maglev`.
- `ruby_version` - String - The Ruby version you want to install.
- `rubies_path` - String - Path to install the rubies to.
  Defaults to: ruby-install's default. Currently: `/opt/rubies`
- `update_path` - Boolean - Default: `false`  
   Set to true to set the Ruby version to path.
   Requires the `user` attribute to be set.
- `user` - String - User for which to install the Ruby version.
- `environment` - Hash - environment variables to be set.

## License

This cookbook is released under the MIT License.
See the bundled LICENSE file for details.
