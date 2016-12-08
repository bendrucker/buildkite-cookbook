version = node['buildkite']['version']
architecture = node['buildkite']['architecture'] == '32' ? '386' : 'amd64'
filename = "buildkite-agent-windows-#{architecture}-#{version}.zip"
url = "https://github.com/buildkite/agent/releases/download/v#{version}/#{filename}"
directory = Chef::Config[:file_cache_path] + '\\buildkite'
agent = directory + '\\buildkite-agent.exe'

winsw 'buildkite-agent' do
  executable agent
  args ['start', '--config', node['buildkite']['conf_path']]
  action :nothing
end

windows_zipfile directory do
  source url
  checksum node['buildkite']['checksum'] if node['buildkite']['checksum']
  overwrite true

  notifies :stop, 'winsw[buildkite-agent]', :before
  notifies :install, 'winsw[buildkite-agent]'

  not_if "#{agent} --version | find /i \"#{version}\"" 
end