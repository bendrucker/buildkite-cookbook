module Buildkite
  module Conf
    def render_conf(defaults, overrides = {})
      wrapper = ''
      defaults.to_hash.merge(overrides).reduce('') do |acc, (key, value)|
        wrapper = ''
        if [true, false].include?(value)
          value = value ? 'true' : 'false'
        else
          wrapper = '"'
        end

        if key == 'meta-data' && value.is_a?(Hash)
          value = value.map { |meta_key, meta_value| [meta_key, meta_value].join('=') }.join(',')
        end

        acc + key + '=' + wrapper + value + wrapper + $INPUT_RECORD_SEPARATOR
      end
    end
  end
end
