Chef::Resource::File.send(:include, Buildkite::Conf)

file '/etc/apt/sources.list.d/buildkite-agent.list' do
  repo = node['buildkite']['apt']['repo']
  releases = node['buildkite']['apt']['releases'].join(' ')
  content "deb #{repo} #{releases}"
end

apt_repository 'buildkite' do
  uri node['buildkite']['apt']['repo']
  distribution node['lsb']['codename']
  components node['buildkite']['apt']['releases']
  key node['buildkite']['apt']['key']
  distribution nil
end

include_recipe 'apt'

apt_package 'buildkite-agent' do
  version node['buildkite']['version']
end

file node['buildkite']['paths']['conf'] do
  keys = node['buildkite']['token']
  token = Chef::EncryptedDataBagItem.load(keys[0], keys[1])[keys[2]]

  content render_conf(
    node['buildkite']['conf'],
    'token' => token
  )

  notifies :restart, 'service[buildkite-agent]'
end

service 'buildkite-agent' do
  action [:enable, :start]
end

%w(ssh hooks).each do |key|
  directory node['buildkite']['paths'][key] do
    recursive true
    owner node['buildkite']['user']
    group node['buildkite']['user']
  end
end
