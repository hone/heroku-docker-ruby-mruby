module CLI
  class Env
    def initialize(profiled_path)
      @env = {}

      File.open(profiled_path, "r") do |file|
        file.readlines.each do |line|
          key, value = line.sub("export ", "").split("=", 2)
          @env[key] = value
        end
      end
    end

    def [](key)
      @env[key]
    end

    def to_h
      @env
    end
  end
end
