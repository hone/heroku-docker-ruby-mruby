module CLI
  class InstallBundler
    def initialize(output_io)
      @output_io = output_io
    end

    def run(version, config_path, profiled_path)
      command = "gem install bundler --no-ri --no-rdoc -v #{version}"

      Util.pipe(command, @output_io, profiled_path)

      write_profiled(profiled_path, config_path)
    end

    private
    def write_profiled(profiled_path, config_path)
      env      = Env.new(profiled_path)
      profiled = Profiled.new
      profiled.override("PATH", "#{env["GEM_HOME"]}/bin#{File::PATH_SEPARATOR}$PATH")
      profiled.override("BUNDLE_APP_CONFIG", config_path)

      File.open(profiled_path, 'a') {|file| file.puts profiled.string }
    end
  end
end
