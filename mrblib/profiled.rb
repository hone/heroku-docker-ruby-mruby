class Profiled
  def initialize
    @data = StringIO.new
  end

  def override(key, value)
    @data.puts %Q{export #{key}="#{value}"}
  end

  def default(key, value)
    @data.puts %Q{export #{key}=${#{key}:-"#{value}"}}
  end

  def string
    @data.string
  end
end
