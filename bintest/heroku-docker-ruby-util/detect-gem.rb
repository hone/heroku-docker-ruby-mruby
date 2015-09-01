require 'open3'
require 'tmpdir'
require_relative '../support/paths'

assert('detect-gem') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "rack"
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

      output, status = Open3.capture2(BIN_PATH, "bundle-install", "#{install_path}/bundle", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      output, status = Open3.capture2(BIN_PATH, "detect-gem", profiled_path, "rack")
      assert_include output, "1.6.4"
    end
  end
end
