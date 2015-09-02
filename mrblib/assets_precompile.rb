module CLI
  class AssetsPrecompile
    def initialize(output_io)
      @output_io = output_io
    end
    
    def run(rakefile_path, profiled_path)
      error_file    = "/tmp/ruby-error-#{rand(Time.now.usec)}"
      error_rescued = false
      status        = nil

      Dir.chdir(File.dirname(rakefile_path)) do
        Util.pipe("bundle exec rake assets:precompile 2>#{error_file}", @output_io, profiled_path)
        status = $?

        error = File.read(error_file)
        if error.include?("No Rakefile found")
          @output_io.puts "No Rakefile found"
          error_rescued = true
        end
        if error.include?("Don't know how to build task 'assets:precompile'")
          @output_io.puts "'assets:precompile' task was not found"
          error_rescued = true
        end
      end
    ensure
      File.unlink(error_file)
      exit(status.exitstatus) if status && !status.success? && !error_rescued
    end
  end
end
