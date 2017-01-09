if platform?('ubuntu')
  default['buildkite']['version'] = '2.3.2-1408'
  default['buildkite']['user'] = 'buildkite-agent'
  paths = default['buildkite']['paths'] = {
    'ssh' => '/var/lib/buildkite-agent/.ssh',
    'conf' => '/etc/buildkite-agent/buildkite-agent.cfg',
    'hooks' => '/etc/buildkite-agent/hooks'
  }

  default['buildkite']['conf']['build-path'] = %w(
    /var
    lib
    buildkite-agent
    builds
  ).join('/')

  default['buildkite']['conf']['bootstrap-script'] = %w(
    /usr
    share
    buildkite-agent
    bootstrap.sh
  ).join('/')

  default['buildkite']['conf']['hooks-path'] = paths['hooks']

  default['buildkite']['conf']['meta-data']['os'] = 'ubuntu'
end
