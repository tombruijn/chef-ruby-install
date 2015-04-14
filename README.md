# ruby-install Chef cookbook

Installs postmodern's [ruby-install](https://github.com/postmodern/ruby-install)
and optionally Ruby versions.

## Dependencies

- git

## Recipes

### ruby-install::default

This default recipe will install ruby-install.
Using the `git_url` attribute it will download a Git repository.
The `git_ref` will allow you to select a version.
Please select one of the tags from the
[original repository](https://github.com/postmodern/ruby-install/releases).

### ruby-install::install

This recipe will also use ruby-install to install rubies.
One or more can be specified using the attributes.

The same can be accomplished by using the `ruby_install_ruby` provider
(which this recipe uses).

*The `ruby_install_ruby` provider accepts more
configurable options than the recipe does, so if you need any of them;
use the provider. More information in the providers section.*

## Attributes

All attributes are scoped within the `ruby-install` node attribute.
See also example below.

- `git_url` - String - Optional -
  Default: `https://github.com/postmodern/ruby-install.git`
- `git_ref` - String - Optional - Default: `v0.4.3`
- `install_path` - String - Optional -
  Defaults to: `/var/chef/cache/ruby-install`  
  Path to install `ruby-install` in.  
  (*Default value uses the `file_cache_path` attribute from Chef's config.*)
- `rubies` - Array - Default: []  
  Each array element is a Hash with the following attributes:
  - `ruby` - String - Required - `ruby-install` specific Ruby version
    selector.  
    Examples: `ruby`, `ruby 2.0.0-p353` or `rubinius stable`.  
    *Keywords such as `stable` are supported but not recommended. See
    `ruby_install_ruby` provider for more information.*
  - `user` - String - Optional - User for which to install the Ruby version.  
    If used, make sure that the user is allowed to write in the default
    directories, if you use them, and if the user is allowed to allow
    `ruby-install` to install packages.
  - `group` - String - Optional - Group for which to install the Ruby version.
  - `reinstall` - Boolean - Optional - Default: `false`  
    Set to `true` to reinstall the ruby.
  - `md5` - String - Optional  
     MD5 checksum of the Ruby archive.
  - `sha1` - String - Optional  
    SHA1 checksum of the Ruby archive.
  - `sha256` - String - Optional  
    SHA256 checksum of the Ruby archive.
  - `sha512` - String - Optional  
    SHA512 checksum of the Ruby archive.
  - `gems` - Array - Optional - Default: `[]`  
    Each array element is a Hash with the following attributes:
    - `name` - Required - Name of the gem to install.
    - `version` - Optional - Version of the gem to install.
    - Other gem install options are not supported by chef's `gem_package`.

Example:

```ruby
{
  "ruby-install" => {
    git_url: "https://github.com/postmodern/ruby-install.git",
    git_ref: "v0.4.3",
    install_path: "/home/vagrant/ruby-install",
    rubies: [
      {
        ruby: "ruby 2.0.0-p451",
        user: "vagrant",
        group: "vagrant",
        reinstall: true,
        gems: [
          { name: "bundler", version: "1.5.1" }
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
  *Keywords such as stable are not recommended as their actual version change
  with each release.*
- `gems` - Array - List of gems to install.  
  Each array element is a hash that specify which gems to install.
  See the `ruby-install::install` recipe for the format of each hash.
- `user` - String - User for which to install the Ruby version.
- `group` - String - Group for which to install the Ruby version.
- `environment` - Hash - environment variables to be set.

The following are `ruby-install` specific options. If no value is specified
it will use the `ruby-install default`.  
However, `src_dir` and `install_dir` are the only two exceptions to this.
See the exceptions heading under the list.

- `src_dir` - String - Optional  
  Directory to download source-code into.
- `install_dir` - String - Optional  
  Directory to install Ruby into.
- `patch` - String - Optional  
  Patch to apply to the Ruby source-code.
- `mirror` - String - Optional  
  Alternate mirror to download the Ruby archive from.
- `url` - String - Optional  
  Alternate URL to download the Ruby archive from.
- `md5` - String - Optional  
  MD5 checksum of the Ruby archive.
- `sha1` - String - Optional  
  SHA1 checksum of the Ruby archive.
- `sha256` - String - Optional  
  SHA256 checksum of the Ruby archive.
- `sha512` - String - Optional  
  SHA512 checksum of the Ruby archive.
- `no_download` - Boolean - Optional - Default `false`  
  Use the previously downloaded Ruby archive
- `no_verify` - Boolean - Optional - Default `false`  
  Do not verify the downloaded Ruby archive
- `no_install_deps` - Boolean - Optional - Default `false`  
  Do not install build dependencies before installing Ruby
- `no_reinstall` - Boolean - Optional - Default `false`  
  Skip installation if another Ruby is detected in same location.

Exceptions:

- `src_dir` is set the the users home dir `$HOME/rubies-src` if `user` is
  specified.
- `install_dir` is always set so that the provider can call it to install
  gems and update the path if specified. It will default to
  `$HOME/.rubies/$RUBY` for a user install and `/opt/rubies/$RUBY` for a
  system install. `$RUBY` is the ruby string you specified with the spaces
  ` ` replaced with dashes `-`.

## Development

Issue reports and pull requests are appreciated on
[GitHub](https://github.com/tombruijn/chef-ruby-install).

### Releases

New releases are released with the [emeril](https://github.com/fnichol/emeril)
gem on the Opscode
[Community site](http://community.opscode.com/cookbooks/ruby-install).

## License

This cookbook is released under the MIT License.
See the bundled LICENSE file for details.
