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
  end
end
