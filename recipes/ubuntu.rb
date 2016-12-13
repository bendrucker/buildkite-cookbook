Chef::Resource::File.send(:include, Buildkite::Conf)

file '/etc/apt/sources.list.d/buildkite-agent.list' do
  content "deb #{node['buildkite']['apt']['repo']} #{node['buildkite']['apt']['releases'].join(' ')}"
end

apt_repository 'buildkite' do
  uri node['buildkite']['apt']['repo']
  distribution node['lsb']['codename']
  components node['buildkite']['apt']['releases']
  key node['buildkite']['apt']['key']
end

include_recipe 'apt'

apt_package 'buildkite-agent' do
  version node['buildkite']['version']
end

file node['buildkite']['conf_path'] do
  token_path = node['buildkite']['token']

  content render_conf(node['buildkite']['conf'], 'token' => Chef::EncryptedDataBagItem.load(token_path[0], token_path[1])[token_path[2]])

  notifies :restart, 'service[buildkite-agent]'
end

service 'buildkite-agent' do
  action [:enable, :start]
end
