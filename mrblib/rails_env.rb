module CLI
  class RailsEnv
    def initialize
    end

    def run(profiled_path)
      write_profiled(profiled_path)
    end

    private
    def write_profiled(profiled_path)
      Util.mkdir_p(File.dirname(profiled_path))

      profiled = Profiled.new
      profiled.default("RAILS_ENV", "production")
      profiled.default("SECRET_KEY_BASE", generate_key)

      File.open(profiled_path, 'a') {|file| file.puts profiled.string }
    end

    def generate_key
      random = StringIO.new
      Util.pipe("openssl rand -base64 32", random)

      random.string.chomp
    end
  end
end
