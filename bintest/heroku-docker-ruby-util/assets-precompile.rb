require 'open3'
require 'tmpdir'
require_relative '../support/paths'

assert('assets-precompile with Rakefile') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "rake"
GEMFILE
      end

      File.open("Gemfile.lock", "w") do |file|
        file.puts <<GEMFILE_LOCK
GEM
  remote: https://rubygems.org/
  specs:
    rack (1.6.4)

PLATFORMS
  ruby

DEPENDENCIES
  rack
GEMFILE_LOCK
      end

      File.open("Rakefile", "w") do |file|
        file.puts <<RAKEFILE
namespace :assets do
  task :precompile do
    puts "compiling"
  end
end
RAKEFILE
      end

      install_path  = "ruby"
      profiled_path = ".profile.d/ruby.sh"

      output, status = Open3.capture2(BIN_PATH, "install-ruby", "Gemfile", install_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      output, status = Open3.capture2(BIN_PATH, "install-bundler", "1.9.7", "#{install_path}/.bundle/config", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      output, status = Open3.capture2(BIN_PATH, "install-node", "0.12.7", install_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      output, status = Open3.capture2(BIN_PATH, "rails-env", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      output, status = Open3.capture2(BIN_PATH, "assets-precompile", "Rakefile", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      assert_include output, "compiling"
    end
  end
end

assert('assets-precompile with no Rakefile') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "rake"
GEMFILE
      end

      File.open("Gemfile.lock", "w") do |file|
        file.puts <<GEMFILE_LOCK
GEM
  remote: https://rubygems.org/
  specs:
    rack (1.6.4)

PLATFORMS
  ruby

DEPENDENCIES
  rack
GEMFILE_LOCK
      end

      install_path  = "ruby"
      profiled_path = ".profile.d/ruby.sh"

      output, status = Open3.capture2(BIN_PATH, "install-ruby", "Gemfile", install_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      output, status = Open3.capture2(BIN_PATH, "install-bundler", "1.9.7", "#{install_path}/.bundle/config", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      output, status = Open3.capture2(BIN_PATH, "install-node", "0.12.7", install_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      output, status = Open3.capture2(BIN_PATH, "rails-env", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      output, status = Open3.capture2(BIN_PATH, "assets-precompile", "Rakefile", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      assert_include output, "No Rakefile found"
    end
  end
end

assert('assets-precompile with Rakefile but missing task') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "rake"
GEMFILE
      end

      File.open("Gemfile.lock", "w") do |file|
        file.puts <<GEMFILE_LOCK
GEM
  remote: https://rubygems.org/
  specs:
    rack (1.6.4)

PLATFORMS
  ruby

DEPENDENCIES
  rack
GEMFILE_LOCK
      end

      File.open("Rakefile", "w") do |file|
        file.puts <<RAKEFILE
task :foo do
  puts "foo"
end
RAKEFILE
      end

      install_path  = "ruby"
      profiled_path = ".profile.d/ruby.sh"

      output, status = Open3.capture2(BIN_PATH, "install-ruby", "Gemfile", install_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      output, status = Open3.capture2(BIN_PATH, "install-bundler", "1.9.7", "#{install_path}/.bundle/config", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      output, status = Open3.capture2(BIN_PATH, "install-node", "0.12.7", install_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      output, status = Open3.capture2(BIN_PATH, "rails-env", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      output, status = Open3.capture2(BIN_PATH, "assets-precompile", "Rakefile", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      assert_include output, "'assets:precompile' task was not found"
    end
  end
end
