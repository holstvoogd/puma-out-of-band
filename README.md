# puma-out-of-band

A puma plugin to create a single worker & bind(s) bypassing the the primary worker queue(s).

This can be used to create a priority channel, for instance to ensure health checks are not queued. While this should probably never be nescesarry, legacy happens.
It can also be used to add a custom rack app, for instance some management interface or api.

By default all requests are passed to the primary application, securing the additional binds to prevent misuse is your responsibility!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'puma-out-of-band'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install puma-out-of-band

## Usage

Add following lines to your puma `config.rb` (see
[Configuration File](https://github.com/puma/puma#configuration-file)):

```ruby
# config/puma.rb

plugin 'oob'
oob_bind 'tcp://0.0.0.0:8081'
```

### Configuation

You may pass optional configuration to oob_config:

```ruby
oob_bind 'tcp://0.0.0.0:8081' # support tcp/ssl/unix bind, maybe called multiple times
oob_config  min_threads: 1, # Default = 0
            max_threads: 2, # Default = 1
            app: ->(env) { [200, {}, ["Hello world!"]]} # Defaults to you application, any rack app can be used.
```

## Credits

The gem is inspired by the following projects:

* https://github.com/harmjanblok/puma-metrics
* https://github.com/tkishel/puma-stats

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

