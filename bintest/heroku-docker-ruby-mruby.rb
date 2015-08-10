require 'open3'
require 'tmpdir'

BIN_PATH = File.join(File.dirname(__FILE__), "../mruby/bin/heroku-docker-ruby-mruby")

assert('detect-ruby') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "rack"
GEMFILE
      end

      output, status = Open3.capture2("#{BIN_PATH}", "detect-ruby", "Gemfile")

      assert_true status.success?, "Process did not exit cleanly"
      assert_include output, "ruby-2.2.2"
    end
  end
end

assert('install-ruby') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "rack"
GEMFILE
      end
      install_path = "ruby"

      output, status = Open3.capture2("#{BIN_PATH}", "install-ruby", "Gemfile", install_path)

      assert_true status.success?, "Process did not exit cleanly"
      assert_true Dir.exist?("#{install_path}/ruby-2.2.2")
    end
  end
end
