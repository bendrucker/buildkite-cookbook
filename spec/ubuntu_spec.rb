require_relative './spec_helper'

describe 'buildkite::ubuntu' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new({
      file_cache_path: '/cache',
      platform: 'ubuntu',
      version: '16.04'
    })
    .converge described_recipe
  end

  it 'adds the apt source' do
    expect(chef_run)
      .to render_file('/etc/apt/sources.list.d/buildkite-agent.list')
      .with_content('deb https://apt.buildkite.com/buildkite-agent stable main')
  end

  it 'adds the apt repository' do
    expect(chef_run)
      .to add_apt_repository('buildkite')
      .with({
        uri: 'https://apt.buildkite.com/buildkite-agent',
        distribution: 'xenial',
        components: ['stable', 'main'],
        key: '32A37959C2FA5C3C99EFBC32A79206696452D198'
      })
  end

  it 'runs apt update' do
    expect(chef_run).to include_recipe('apt')
  end

  it 'installs the buildkite agent' do
    expect(chef_run)
      .to install_apt_package('buildkite-agent')
      .with(version: '2.3.2')
  end
end