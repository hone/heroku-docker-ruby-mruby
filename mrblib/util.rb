module Util
  class << self
    def mkdir_p(dir)
      dir.split("/").inject("") do |parent, base|
        next if base == ""

        new_dir =
          if parent == ""
            base
          else
            "#{parent}/#{base}"
          end

        if !Dir.exist?(new_dir)
          Dir.mkdir(new_dir)
        end

        new_dir
      end
    end

    def pipe(command, output_io = $stdout)
      IO.popen(command) do |io|
        while data = io.read(16)
          output_io.print data
        end
      end
    end

  end
end
