buildkite_hook 'environment' do
  code <<~EOH
    export FOO=bar
  EOH
end
