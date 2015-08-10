def __main__(argv)
  argv.shift
  command = argv.shift

  case command
  when "detect-ruby"
    gemfile_path = argv.shift
    puts CLI::DetectRuby.new(File.read(gemfile_path)).ruby_version
  when "install-ruby"
    gemfile_path = argv.shift
    install_path = argv.shift

    CLI::InstallRuby.new($stdout).run(File.read(gemfile_path), install_path)
  end
end
