module Buildkite
  # Provides configuration helpers for rendering configuration
  module Conf
    def render_conf(defaults, overrides = {})
      defaults.to_hash.merge(overrides).reduce('') do |acc, (key, value)|
        value = render_meta_data(value) if key == 'meta-data'
        acc + render_line(key, value) + separator
      end
    end

    private_class_method
    def boolean?(value)
      [true, false].include?(value)
    end

    private_class_method
    def render_value(value)
      if boolean?(value)
        value ? 'true' : 'false'
      else
        value
      end
    end

    private_class_method
    def render_wrapper(value)
      boolean?(value) ? '' : '"'
    end

    private_class_method
    def render_meta_data(value)
      if !value.is_a?(Hash)
        value
      else
        value
          .map do |meta_key, meta_value|
            [meta_key, meta_value].join('=')
          end
          .join(',')
      end
    end

    private_class_method
    def render_line(key, value)
      wrapper = render_wrapper value
      key + '=' + wrapper + render_value(value) + wrapper
    end

    private_class_method
    def separator
      $INPUT_RECORD_SEPARATOR || "\n"
    end
  end
end
