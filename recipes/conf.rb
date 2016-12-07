file node['buildkite']['conf_path'] do
  token_path = node['buildkite']['token']
  token = Chef::EncryptedDataBagItem.load(token_path[0], token_path[1])[token_path[2]]
  content ({'token' => token}).merge(node['buildkite']['conf']).reduce('') do |acc, (key, value)|
    wrapper = ''
    if [true, false].include?(value)
      value = value ? 'true' : 'false'
    else
      wrapper = '"'
    end

    acc + key + '=' + wrapper + value + wrapper + $/
  end
end