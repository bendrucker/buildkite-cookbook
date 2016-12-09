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

        if key == 'meta-data' && value.kind_of?(Hash)
          value = value.map { |key, value| [key, value].join('=') }.join(',')
        end

        acc + key + '=' + wrapper + value + wrapper + $/
      end
    end
  end
end