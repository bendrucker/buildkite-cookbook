if platform?('windows')
  bootstrap = ::File.join(
    Chef::Config[:file_cache_path],
    'buildkite',
    'bootstrap.bat'
  )

  default['buildkite']['version'] = '2.3.2'
  default['buildkite']['conf']['bootstrap-script'] = bootstrap

  default['buildkite']['release'] = {
    'filename' => %w(
      buildkite
      agent
      windows
      :architecture:
      :version:.zip
    ).join('-'),
    'url' => %w(
      https://github.com
      buildkite
      agent
      releases
      download
      v:version:
      :filename:
    ).join('/')
  }
end
