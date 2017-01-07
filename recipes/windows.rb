Chef::Resource::File.send(:include, Buildkite::Conf)

version = node['buildkite']['version']
architecture = node['buildkite']['architecture'] == '32' ? '386' : 'amd64'

filename = node['buildkite']['release']['filename']
  .gsub(':architecture:', architecture)
  .gsub(':version:', version)

url = node['buildkite']['release']['url']
  .gsub(':version:', version)
  .gsub(':filename:', filename)

directory = Chef::Config[:file_cache_path] + '\\buildkite'
agent = directory + '\\buildkite-agent.exe'

Chef::Resource::File.send(:include, Buildkite::Conf)

conf_path = node['buildkite']['paths']['conf']

file conf_path do
  keys = node['buildkite']['token']
  token = Chef::EncryptedDataBagItem.load(keys[0], keys[1])[keys[2]]

  content render_conf(
    node['buildkite']['conf'],
    'token' => token
  )

  notifies :restart, 'winsw[buildkite-agent]'
end

winsw 'buildkite-agent' do
  executable agent
  args ['start', '--config', conf_path.tr('\\', '/')]

  options(
    workingdirectory: directory,
    stopparentprocessfirst: true
  )
end

windows_zipfile directory do
  source url
  checksum node['buildkite']['checksum'] if node['buildkite']['checksum']
  overwrite true

  notifies :stop, 'winsw[buildkite-agent]', :before
  notifies :install, 'winsw[buildkite-agent]'

  not_if "#{agent} --version | find /i \"#{version}\""
end
