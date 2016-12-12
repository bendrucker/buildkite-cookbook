if platform?('ubuntu')
  default['buildkite']['version'] = '2.3.2-1408'
  default['buildkite']['user'] = 'buildkite-agent'
  default['buildkite']['ssh_path'] = '/var/lib/buildkite-agent/.ssh/'
  default['buildkite']['conf_path'] = '/etc/buildkite-agent/buildkite-agent.cfg'
  default['buildkite']['conf']['build-path'] = '/var/lib/buildkite-agent/builds/'
  default['buildkite']['conf']['bootstrap-script'] = '/usr/share/buildkite-agent/bootstrap.sh'
  default['buildkite']['conf']['meta-data']['os'] = 'ubuntu'
end