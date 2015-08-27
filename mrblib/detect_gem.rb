module CLI
  class DetectGem
    def initialize(profiled_path)
      env = Env.new(profiled_path)
      @specs_dir = "#{env["GEM_HOME"]}/specifications"
    end

    def gem(name)
      file = gemspec_file(name)
      return unless file

      Gem::Specification.parse(File.read("#{@specs_dir}/#{file}")).version
    end

    def gemspec_file(name)
      gemspec_regexp = Regexp.compile("#{name}(-aix|cygwin|darwin|macruby|freebsd|hpux|java|dalvik|dotnet|linux|mingw32|netbsdelf|openbsd|bitrig|solaris|unknown)?-[0-9]+\.[0-9]+\.[0-9]\.gemspec")
      Dir.entries(@specs_dir).entries.detect do |filename|
        gemspec_regexp =~ filename
      end
    end
  end
end
