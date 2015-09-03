module CLI
  class BundleInstall
    def initialize(output_io)
      @output_io = output_io
    end

    def run(vendor_path, profiled_path)
      command = "bundle install --path #{vendor_path} --jobs 4"
      Util.pipe(command, @output_io, profiled_path)
      exit($?.exitstatus) unless $?.success?
    end
  end
end
