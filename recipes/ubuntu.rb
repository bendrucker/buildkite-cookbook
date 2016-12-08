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