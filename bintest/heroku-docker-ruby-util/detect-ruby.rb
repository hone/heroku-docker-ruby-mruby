require 'open3'
require 'tmpdir'
require_relative '../support/paths'

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

      output, status = Open3.capture2(BIN_PATH, "detect-ruby", "Gemfile")

      assert_true status.success?, "Process did not exit cleanly"
      assert_include output, "ruby-2.2.2"
    end
  end
end
