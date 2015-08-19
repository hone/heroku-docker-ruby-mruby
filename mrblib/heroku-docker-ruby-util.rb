def __main__(argv)
  argv.shift
  command = argv.shift

  case command
  when "detect-ruby"
    gemfile_path = argv.shift
    puts CLI::DetectRuby.new(File.read(gemfile_path)).ruby_version
  when "install-ruby"
    gemfile_path  = argv.shift
    install_path  = argv.shift
    profiled_path = argv.shift

    CLI::InstallRuby.new($stdout).run(File.read(gemfile_path), install_path, profiled_path)
  when "install-node"
    node_version  = argv.shift
    install_path  = argv.shift
    profiled_path = argv.shift

    CLI::InstallNode.new($stdout).run(node_version, install_path, profiled_path)
  when "install-bundler"
    bundler_version = argv.shift
    config_path     = argv.shift
    profiled_path   = argv.shift

    CLI::InstallBundler.new($stdout).run(bundler_version, config_path, profiled_path)
  when "bundle-install"
    vendor_path   = argv.shift
    profiled_path = argv.shift

    CLI::BundleInstall.new($stdout).run(vendor_path, profiled_path)
  when "rails-env"
    profiled_path = argv.shift

    CLI::RailsEnv.new.run(profiled_path)
  when "assets-precompile"
    rakefile_path = argv.shift
    profiled_path = argv.shift

    CLI::AssetsPrecompile.new($stdout).run(rakefile_path, profiled_path)
  else
    $stderr.puts "#{command} not a valid command"
  end
end
