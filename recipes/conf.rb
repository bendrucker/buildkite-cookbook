file node['buildkite']['conf_path'] do
  token_path = node['buildkite']['token']
  token = Chef::EncryptedDataBagItem.load(token_path[0], token_path[1])[token_path[2]]
  
  bootstrap_script = case node['platform']
    when 'windows'
      [::File.join(Chef::Config[:file_cache_path], 'buildkite', 'buildkite-agent.exe'), 'boostrap'].join(' ')
    else
      'buildkite bootstrap'
  end

  content ({
    'token' => token,
    'bootstrap-script' => bootstrap_script
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