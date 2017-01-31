class CommandLine
  USAGE = <<USAGE
Heroku Docker Ruby Util.

    Usage:
      ruby-util detect-ruby <gemfile-path>
      ruby-util detect-gem <profiled-path> <gem>
      ruby-util install-ruby <gemfile-path> <install-path> <profiled-path>
      ruby-util install-node <node-version> <install-path> <profiled-path>
      ruby-util install-bundler <bundler-version> <config-path> <profiled-path>
      ruby-util bundle-install <vendored-path> <profiled-path>
      ruby-util rails-env <profiled-path>
      ruby-util assets-precompile <rakefile-path> <profiled-path>
      ruby-util database-yml <install-path> <profiled-path>
      ruby-util (-h | --help)

    Options:
      -h --help  Show this message
USAGE

  def run(argv)
    options = Docopt.parse(USAGE, argv)

    if options.nil?
      $stderr.puts "#{argv[1]} not a valid command"
    elsif options["detect-ruby"]
      puts CLI::DetectRuby.new(File.read(options["<gemfile-path>"])).ruby_version
    elsif options["detect-gem"]
      puts CLI::DetectGem.new(options["<profiled-path>"]).gem(options["<gem-path>"])
    elsif options["install-ruby"]
      CLI::InstallRuby.new($stdout).run(File.read(options["<gemfile-path>"]), options["<install-path>"], options["<profiled-path>"])
    elsif options["install-node"]
      CLI::InstallNode.new($stdout).run(options["<node-version>"], options["<install-path>"], options["<profiled-path>"])
    elsif options["install-bundler"]
      CLI::InstallBundler.new($stdout).run(options["<bundler-version>"], options["<config-path>"], options["<profiled-path>"])
    elsif options["bundle-install"]
      CLI::BundleInstall.new($stdout).run(options["<vendored-path>"], options["<profiled-path>"])
    elsif options["rails-env"]
      CLI::RailsEnv.new.run(options["<profiled-path>"])
    elsif options["assets-precompile"]
      CLI::AssetsPrecompile.new($stdout).run(options["<rakefile-path>"], options["<profiled-path>"])
    elsif options["database-yml"]
      CLI::DatabaseYml.new.run(options["<install-path>"], options["<profiled-path>"])
    else
      puts USAGE
    end
  end
end
