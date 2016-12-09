if platform?('windows')
  default['buildkite']['version'] = '2.3.2'
  default['buildkite']['conf']['bootstrap-script'] = ::File.join(Chef::Config[:file_cache_path], 'buildkite', 'buildkite-agent.exe') + ' bootstrap'
end