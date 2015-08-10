class RubyVersion
  attr_reader :version, :patchlevel, :engine, :engine_version

  def initialize(version, patchlevel = nil, engine = nil, engine_version = nil)
    @version        = version
    @patchlevel     = patchlevel
    @engine         = engine
    @engine_version = engine_version
  end

  def to_s
    components = ["ruby", version]
    components << "p#{patchlevel}" if patchlevel
    (components + [engine, engine_version]).compact.join("-")
  end
end
