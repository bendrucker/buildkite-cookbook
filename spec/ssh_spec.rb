require_relative './spec_helper'

describe 'buildkite::ssh' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new({
      file_cache_path: '/cache',
      platform: 'ubuntu',
      version: '16.04',
      step_into: ['buildkite_key']
    })
    .converge 'ubuntu-test::ssh'
  end

  it 'installs the ssh key' do
    expect(chef_run)
      .to create_file('/var/lib/buildkite-agent/.ssh/id_rsa')
      .with({
        content: '-----BEGIN RSA PRIVATE KEY-----',
        user: 'buildkite-agent',
        group: 'buildkite-agent',
        mode: '0400'
      })
  end
end