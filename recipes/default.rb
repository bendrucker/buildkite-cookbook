include_recipe 'git'

log 'conf' do
  level 'debug'
  message Chef::JSONCompat.to_json_pretty(node['buildkite'])
end

include_recipe 'buildkite::windows' if platform?('windows')
include_recipe 'buildkite::ubuntu' if platform?('ubuntu')
