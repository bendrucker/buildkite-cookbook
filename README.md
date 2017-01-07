# buildkite-cookbook [![Build Status](https://travis-ci.org/bendrucker/buildkite-cookbook.svg?branch=master)](https://travis-ci.org/bendrucker/buildkite-cookbook)

> Installs and configures the buildkite agent and provides resources for creating SSH keys and hooks

## Requirements

* A [Buildkite](https://buildkite.com/) account
* A supported operating system
  - Ubuntu
  - Windows

## Recipes

#### buildkite::default

Installs and runs the buildkite agent as a service on your platform. 

* The recipe will attempt to load your Buildkite API key from an encrypted data bag using the path specified in `node['buildkite']['token']` (`credentials buildkite token` by default)
* The configuration file is built from the `node['buildkite']['conf']` object
  - The `meta-data` key may also be an object that will be converted into a `key=value` string

The recipe will notify the `buildkite-agent` service to restart whenever your configuration file changes.

## Resources

Custom resources are currently available only for Ubuntu.

#### buildkite_key

Creates an SSH key for use by the Buildkite agent.

```ruby
buildkite_key 'id_rsa' do
  content my_private_key
end
```

#### buildkite_hook

Creates a [Buildkite global hook script](https://buildkite.com/docs/agent/hooks).

```ruby
buildkite_hook 'environment' do
  code <<~EOH
    export FOO=bar
  EOH
end
```

## License

MIT © [Ben Drucker](http://bendrucker.me)
