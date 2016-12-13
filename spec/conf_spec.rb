require_relative './spec_helper'

describe Buildkite::Conf do
  let(:conf) do
    Class.new do
      include Buildkite::Conf
    end
  end

  describe 'render_conf' do
    it 'renders defaults' do
      expect(conf.new.render_conf('foo' => 'bar')).to eq("foo=\"bar\"\n")
    end

    it 'renders overrides' do
      expect(conf.new.render_conf({ 'foo' => 'bar' }, 'foo' => 'baz')).to eq("foo=\"baz\"\n")
    end

    it 'adds a newline between values' do
      expect(conf.new.render_conf('foo' => 'bar', 'bar' => 'baz')).to eq("foo=\"bar\"\nbar=\"baz\"\n")
    end

    it 'handles meta-data strings' do
      expect(conf.new.render_conf('meta-data' => 'foo=bar')).to eq("meta-data=\"foo=bar\"\n")
    end

    it 'handles meta-data objects' do
      expect(conf.new.render_conf('meta-data' => { 'foo' => 'bar' })).to eq("meta-data=\"foo=bar\"\n")
    end

    it 'handles multi-key meta-data objects' do
      expect(conf.new.render_conf('meta-data' => { 'foo' => 'bar', 'bar' => 'baz' }))
        .to eq("meta-data=\"foo=bar,bar=baz\"\n")
    end
  end
end
