module CLI
  class InstallBundler
    def initialize(output_io)
      @output_io = output_io
    end

    def run(version, profiled_path)
      command = "gem install bundler --no-ri --no-rdoc -v #{version}"

      Util.pipe(command, @output_io, profiled_path)

      write_profiled(profiled_path)
    end

    private
    def write_profiled(profiled_path)
      env      = Env.new(profiled_path)
      profiled = Profiled.new
      profiled.override("PATH", "#{env["GEM_HOME"]}/bin#{File::PATH_SEPARATOR}$PATH")

      File.open(profiled_path, 'a') {|file| file.puts profiled.string }
    end
  end
end
