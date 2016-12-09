Chef::Resource::File.send(:include, Buildkite::Conf)

version = node['buildkite']['version']
architecture = node['buildkite']['architecture'] == '32' ? '386' : 'amd64'
filename = "buildkite-agent-windows-#{architecture}-#{version}.zip"
url = "https://github.com/buildkite/agent/releases/download/v#{version}/#{filename}"
directory = Chef::Config[:file_cache_path] + '\\buildkite'
agent = directory + '\\buildkite-agent.exe'

Chef::Resource::File.send(:include, Buildkite::Conf)

file node['buildkite']['conf_path'] do
  token_path = node['buildkite']['token']

  content render_conf(node['buildkite']['conf'], {
    'token' => Chef::EncryptedDataBagItem.load(token_path[0], token_path[1])[token_path[2]]
  })

  notifies :restart, 'winsw[buildkite-agent]' if platform?('windows')
end

winsw 'buildkite-agent' do
  executable agent
  args ['start', '--config', node['buildkite']['conf_path'].gsub('\\', '/')]

  options ({
    workingdirectory: directory,
    stopparentprocessfirst: true
  })
end

windows_zipfile directory do
  source url
  checksum node['buildkite']['checksum'] if node['buildkite']['checksum']
  overwrite true

  notifies :stop, 'winsw[buildkite-agent]', :before
  notifies :install, 'winsw[buildkite-agent]'

  not_if "#{agent} --version | find /i \"#{version}\"" 
end