if platform?('ubuntu')
  default['buildkite']['version'] = '2.3.2-1408'
  default['buildkite']['conf_path'] = '/etc/buildkite-agent/buildkite-agent.cfg'
  default['buildkite']['conf']['build-path'] = '/etc/buildkite-agent/buildkite-agent.cfg'
  default['buildkite']['conf']['bootstrap-script'] = '/usr/share/buildkite-agent/bootstrap.sh'
  default['buildkite']['conf']['meta-data']['os'] = 'ubuntu'
end