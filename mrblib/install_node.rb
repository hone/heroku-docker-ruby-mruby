module CLI
  class InstallNode
    def initialize(output_io)
      @output_io = output_io
    end

    def run(version, install_path, profiled_path)
      Util.mkdir_p(install_path)

      node_install_path = install_path.dup
      node_install_path += "/" unless node_install_path[-1] == "/"
      node_install_path += "node-#{version}"

      command = "curl -s --retry 3 -L http://s3pository.heroku.com/node/v#{version}/node-v#{version}-linux-x64.tar.gz | tar xz -C #{install_path} && mv #{install_path}/node-v#{version}-linux-x64 #{node_install_path}"
      Util.pipe(command, @output_io)

      write_profiled(profiled_path, node_install_path)
    end

    private
    def write_profiled(profiled_path, node_install_path)
      Util.mkdir_p(File.dirname(profiled_path))

      profiled = Profiled.new
      profiled.override("PATH", "#{node_install_path}/bin#{File::PATH_SEPARATOR}$PATH")

      File.open(profiled_path, 'a') {|file| file.puts profiled.string }
    end
  end
end
