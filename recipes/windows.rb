version = node['buildkite']['version']
architecture = node['buildkite']['architecture'] == '32' ? '386' : 'amd64'
filename = "buildkite-agent-windows-#{architecture}-#{version}.zip"
url = "https://github.com/buildkite/agent/releases/download/v#{version}/#{filename}"
directory = ::File.join(Chef::Config[:file_cache_path], 'buildkite')
agent = ::File.join(directory, 'buildkite-agent.exe')

windows_zipfile directory do
  source url
  checksum node['buildkite']['checksum'] if node['buildkite']['checksum']

  notifies :restart, 'winsw[buildkite-agent]'

  not_if "#{agent} --version | find /i \"#{version}\"" 
end

winsw 'buildkite-agent' do
  executable agent
  args ['start']
end