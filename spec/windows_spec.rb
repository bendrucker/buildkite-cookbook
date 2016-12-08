require_relative './spec_helper'
require_relative './support/winsw_matchers'

describe 'buildkite::windows' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new({
      file_cache_path: '/cache',
      platform: 'windows',
      version: '2012R2'
    }) do |node|
      node.normal['buildkite']['version'] = '3.0-beta.16'
    end
  end

  context 'update' do
    before do
      stub_command("/cache/buildkite/buildkite-agent.exe --version | find /i \"3.0-beta.16\"")
        .and_return false

      chef_run.converge described_recipe
    end

    it 'installs buildkite from github releases' do
      expect(chef_run)
        .to unzip_windows_zipfile_to('/cache/buildkite')
        .with({
          source: "https://github.com/buildkite/agent/releases/download/v3.0-beta.16/buildkite-agent-windows-386-3.0-beta.16.zip"
        })
    end

    it 'notifies the service to restart' do
      expect(chef_run.windows_zipfile('/cache/buildkite'))
        .to notify('winsw[buildkite-agent]')
        .to(:restart)
        .delayed
    end

    it 'installs the service' do
      expect(chef_run)
        .to install_winsw('buildkite-agent')
        .with({
          executable: '/cache/buildkite/buildkite-agent.exe',
          args: ['start', '--config', '/cache/buildkite-agent.cfg']
        })
    end
  end

  context 'no update' do
    before do
      stub_command("/cache/buildkite/buildkite-agent.exe --version | find /i \"3.0-beta.16\"")
        .and_return true

      chef_run.converge described_recipe
    end

    it 'skips the zip download' do
      expect(chef_run).not_to unzip_windows_zipfile_to('/cache/buildkite')
    end
  end
end