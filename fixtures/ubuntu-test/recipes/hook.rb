buildkite_hook 'environment' do
  code <<-EOH.strip
  export FOO=bar
  EOH
end
