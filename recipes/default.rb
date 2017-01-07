include_recipe 'git'

log 'conf' do
  level :debug
  message 'buildkite: ' + Chef::JSONCompat.to_json(node['buildkite'])
end

include_recipe 'buildkite::windows' if platform?('windows')
include_recipe 'buildkite::ubuntu' if platform?('ubuntu')
