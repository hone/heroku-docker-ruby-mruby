module CLI
  class DetectRuby
    attr_reader :ruby_version

    def initialize(gemfile)
      self.instance_eval(gemfile)
    end

    private
    def ruby(ruby_version, options = {})
      @ruby_version = RubyVersion.new(ruby_version, options[:patchlevel], options[:engine], options[:engine_version])
    end

    def method_missing(*)
    end
  end
end
