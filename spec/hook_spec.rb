require_relative './spec_helper'

describe 'buildkite::hook' do
  let(:chef_run) do
    ChefSpec::SoloRunner
      .new(
        file_cache_path: '/cache',
        platform: 'ubuntu',
        version: '16.04',
        step_into: ['buildkite_hook']
      )
      .converge 'ubuntu-test::hook'
  end

  it 'installs the ssh key' do
    expect(chef_run)
      .to create_file('/etc/buildkite-agent/hooks/environment')
      .with(
        content: 'export FOO=bar',
        user: 'buildkite-agent',
        group: 'buildkite-agent',
        mode: '0700'
      )
  end
end
