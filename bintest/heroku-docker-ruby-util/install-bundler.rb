require 'open3'
require 'tmpdir'
require_relative '../support/paths'

assert('install-bundler') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "rack"
GEMFILE
      end
      install_path  = "ruby"
      config_path   = "#{install_path}/.bundle/config"
      profiled_path = ".profile.d/ruby.sh"

      output, status = Open3.capture2(BIN_PATH, "install-ruby", "Gemfile", install_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      output, status = Open3.capture2(BIN_PATH, "install-bundler", "1.9.7", config_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      assert_true File.exist?("ruby/bundle/ruby/2.2.0/gems/bundler-1.9.7/"), "Could not find bundler gem"

      output, status = Open3.capture2(%Q{bash -c "source #{profiled_path} && bundle -v"})
      assert_true status.success?, "bundler did not exit cleanly"
      assert_include output, "1.9.7"

      output, status = Open3.capture2(%Q{bash -c "source #{profiled_path} && bundle config" 2>1 })
      assert_true status.success?, "bundler did not exit cleanly"
      assert_include output, %Q{Set via BUNDLE_APP_CONFIG: "#{config_path}"}
    end
  end
end
