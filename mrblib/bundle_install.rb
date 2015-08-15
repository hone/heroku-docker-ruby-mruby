module CLI
  class BundleInstall
    def initialize(output_io)
      @output_io = output_io
    end

    def run(vendor_path, profiled_path)
      command = "bundle install --path #{vendor_path} --deployment --without development:test --jobs 4"
      Util.pipe(command, @output_io, profiled_path)
    end
  end
end
