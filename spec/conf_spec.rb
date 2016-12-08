require_relative './spec_helper'

describe 'buildkite::conf' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new({
      file_cache_path: '/cache',
      platform: 'ubuntu',
      version: '16.04'
    }) do |node|
      node.normal['buildkite']['conf'] = {
        'name' => 'fred',
        'debug' => true
      }
    end.converge described_recipe
  end

  before do
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('credentials', 'buildkite').and_return({
      'token' => 'secret'
    })
  end

  it 'creates the conf file' do
    expect(chef_run)
      .to render_file('/cache/buildkite-agent.cfg')
      .with_content { |content|
        expect(content.split($/)).to match_array([
          'bootstrap-script="buildkite bootstrap"',
          'token="secret"',
          'name="fred"',
          'debug=true',
          'build-path="builds"',
          'name="%hostname-%n"'
        ])
      }
  end
  
end