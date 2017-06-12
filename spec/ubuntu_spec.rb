require_relative './spec_helper'

describe 'buildkite::ubuntu' do
  let(:chef_run) do
    ChefSpec::SoloRunner
      .new(
        file_cache_path: '/cache',
        platform: 'ubuntu',
        version: '16.04'
      ) do |node|
        node.normal['buildkite']['conf']['meta-data']['foo'] = true
      end.converge described_recipe
  end

  before do
    allow(Chef::EncryptedDataBagItem)
      .to receive(:load)
      .with('credentials', 'buildkite')
      .and_return('token' => 'toto')
  end

  it 'adds the apt source' do
    expect(chef_run)
      .to render_file('/etc/apt/sources.list.d/buildkite-agent.list')
      .with_content('deb https://apt.buildkite.com/buildkite-agent stable main')
  end

  it 'adds the apt repository' do
    expect(chef_run)
      .to add_apt_repository('buildkite')
      .with(
        uri: 'https://apt.buildkite.com/buildkite-agent',
        distribution: nil,
        components: %w[stable main],
        key: '32A37959C2FA5C3C99EFBC32A79206696452D198'
      )
  end

  it 'runs apt update' do
    expect(chef_run).to include_recipe('apt')
  end

  it 'installs the buildkite agent' do
    expect(chef_run)
      .to install_apt_package('buildkite-agent')
      .with(version: '2.3.2-1408')
  end

  it 'creates the conf' do
    expect(chef_run)
      .to render_file('/etc/buildkite-agent/buildkite-agent.cfg')
      .with_content <<-EOH.strip
name="%hostname-%n"
build-path="/var/lib/buildkite-agent/builds"
bootstrap-script="/usr/share/buildkite-agent/bootstrap.sh"
hooks-path="/etc/buildkite-agent/hooks"
meta-data="os=ubuntu,foo=true"
token="toto"
      EOH
  end

  it 'notifies the service to restart when conf updates' do
    expect(chef_run.file('/etc/buildkite-agent/buildkite-agent.cfg'))
      .to notify('service[buildkite-agent]')
      .to(:restart)
      .delayed
  end

  it 'enables and starts the buildkite service' do
    expect(chef_run).to enable_service('buildkite-agent')
    expect(chef_run).to start_service('buildkite-agent')
  end

  it 'creates the ssh directory' do
    expect(chef_run)
      .to create_directory('/var/lib/buildkite-agent/.ssh')
      .with(
        recursive: true,
        owner: 'buildkite-agent',
        group: 'buildkite-agent'
      )
  end

  it 'creates the hooks directory' do
    expect(chef_run)
      .to create_directory('/etc/buildkite-agent/hooks')
      .with(
        recursive: true,
        owner: 'buildkite-agent',
        group: 'buildkite-agent'
      )
  end
end
