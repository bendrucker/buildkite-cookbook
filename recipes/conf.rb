file node['buildkite']['conf_path'] do
  token_path = node['buildkite']['token']

  content ({
    'token' => Chef::EncryptedDataBagItem.load(token_path[0], token_path[1])[token_path[2]],
    'bootstrap-script' => "#{Chef::Config[:file_cache_path]}\\buildkite-agent\\buildkite.exe bootstrap"
  })
  .merge(node['buildkite']['conf']).reduce('') do |acc, (key, value)|
    wrapper = ''
    if [true, false].include?(value)
      value = value ? 'true' : 'false'
    else
      wrapper = '"'
    end

    acc + key + '=' + wrapper + value + wrapper + $/
  end
end