include_recipe 'git'
include_recipe 'buildkite::windows' if platform?('windows')
include_recipe 'buildkite::conf'