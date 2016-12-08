default['buildkite']['token'] = ['credentials', 'buildkite', 'token']
default['buildkite']['version'] = '3.0-beta.16'
default['buildkite']['architecture'] = '32'
default['buildkite']['conf_path'] = ::File.join(Chef::Config[:file_cache_path], 'buildkite-agent.cfg')

default['buildkite']['conf'] = {
  'name' => '%hostname-%n',
  'build-path' => 'builds'
}