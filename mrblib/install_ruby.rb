module CLI
  class InstallRuby
    def initialize(output_io)
      @output_io = output_io
    end

    def run(gemfile, install_path)
      ruby = DetectRuby.new(gemfile)
      @output_io.puts "Installing Ruby Version: #{ruby.ruby_version.to_s}"
      install_path += "/" unless install_path[-1] == "/"
      install_path += ruby.ruby_version.to_s

      Util.mkdir_p(install_path)
      command = "curl -s --retry 3 -L https://heroku-buildpack-ruby.s3.amazonaws.com/cedar-14/#{ruby.ruby_version.to_s}.tgz | tar xz -C #{install_path}"
      Util.pipe(command, @output_io)
    end
  end
end
