module CLI
  class InstallRuby
    DEFAULT_RUBY_VERSION = "ruby-2.2.2"

    def initialize(output_io)
      @output_io = output_io
    end

    def run(gemfile, install_path, profiled_path = nil)
      ruby = DetectRuby.new(gemfile)
      ruby_version = ruby.ruby_version ? ruby.ruby_version.to_s : DEFAULT_RUBY_VERSION
      @output_io.puts "Installing Ruby Version: #{ruby_version}"
      ruby_install_path = install_path.dup
      ruby_install_path += "/" unless ruby_install_path[-1] == "/"
      ruby_install_path += ruby_version

      Util.mkdir_p(ruby_install_path)
      command = "curl -s --retry 3 -L https://heroku-buildpack-ruby.s3.amazonaws.com/cedar-14/#{ruby_version}.tgz | tar xz -C #{ruby_install_path}"
      Util.pipe(command, @output_io)

      write_profiled(profiled_path, install_path, ruby_install_path) if profiled_path
    end

    private
    def write_profiled(profiled_path, install_path, ruby_install_path)
      Util.mkdir_p(File.dirname(profiled_path))

      profiled = Profiled.new
      ruby_abi = parse_ruby_abi(ruby_install_path)

      profiled.override("PATH", "#{ruby_install_path}/bin#{File::PATH_SEPARATOR}$PATH")
      if ruby_abi
        profiled.override("GEM_PATH", "#{install_path}/bundle/ruby/2.2.0")
        profiled.override("GEM_HOME", "#{install_path}/bundle/ruby/2.2.0")
      end

      File.open(profiled_path, 'a') {|file| file.puts profiled.string }
    end

    def parse_ruby_abi(install_path)
      abi_regex = Regexp.compile("\d\.\d\.\d")
      abi = Dir.entries("#{install_path}/lib/ruby/").detect {|entry| /^\d\.\d\.\d$/.match(entry) }
      rbconfig_file = "#{install_path}/lib/ruby/#{abi}/x86_64-linux/rbconfig.rb"

      File.open(rbconfig_file) do |file|
        file.readlines.each do |line|
          if line.include?('CONFIG["ruby_version"]')
            return line.split(" = ").last.chomp.gsub('"', '')
          end
        end
      end
    end

  end
end
