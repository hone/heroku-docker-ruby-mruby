module CLI
  class AssetsPrecompile
    def initialize(output_io)
      @output_io = output_io
    end
    
    def run(rakefile_path, profiled_path)
      error_file = "/tmp/ruby-error-#{rand(Time.now.usec)}"

      Dir.chdir(File.dirname(rakefile_path)) do
        Util.pipe("bundle exec rake assets:precompile 2>#{error_file}", @output_io, profiled_path)

        error = File.read(error_file)
        @output_io.puts "No Rakefile found" if error.include?("No Rakefile found")
        @output_io.puts "'assets:precompile' task was not found" if error.include?("Don't know how to build task 'assets:precompile'")
      end
    ensure
      File.unlink(error_file)
    end
  end
end
