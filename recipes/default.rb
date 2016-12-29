include_recipe 'git'

log 'conf' do
  level :info
  message 'conf: ' + Chef::JSONCompat.to_json_pretty(node['buildkite'])
end

include_recipe 'buildkite::windows' if platform?('windows')
include_recipe 'buildkite::ubuntu' if platform?('ubuntu')
