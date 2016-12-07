default['buildkite']['token'] = ['credentials', 'buildkite', 'token']
default['buildkite']['version'] = '2.3.2'
default['buildkite']['architecture'] = '32'
default['buildkite']['conf_path'] = ::File.join(Chef::Config[:file_cache_path], 'buildkite-agent.cfg')
default['buildkite']['conf'] = {}