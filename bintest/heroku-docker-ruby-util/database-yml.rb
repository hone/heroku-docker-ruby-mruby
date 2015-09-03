require 'open3'
require 'tmpdir'
require_relative '../support/paths'

assert('database-yml with new activerecord should not write a database.yml') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "activerecord"
GEMFILE
      end

      File.open("Gemfile.lock", "w") do |file|
        file.puts <<GEMFILE_LOCK
GEM
  remote: https://rubygems.org/
  specs:
    activemodel (4.2.4)
      activesupport (= 4.2.4)
      builder (~> 3.1)
    activerecord (4.2.4)
      activemodel (= 4.2.4)
      activesupport (= 4.2.4)
      arel (~> 6.0)
    activesupport (4.2.4)
      i18n (~> 0.7)
      json (~> 1.7, >= 1.7.7)
      minitest (~> 5.1)
      thread_safe (~> 0.3, >= 0.3.4)
      tzinfo (~> 1.1)
    arel (6.0.3)
    builder (3.2.2)
    i18n (0.7.0)
    json (1.8.3)
    minitest (5.8.0)
    thread_safe (0.3.5)
    tzinfo (1.2.2)
      thread_safe (~> 0.1)

PLATFORMS
  ruby

DEPENDENCIES
  activerecord
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

      output, status = Open3.capture2(BIN_PATH, "database-yml", install_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      assert_false File.exist?("#{install_path}/database.yml"), "database.yml was written to"
    end
  end
end

assert('database-yml with older activerecord should write a database.yml') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.2"

gem "activerecord"
GEMFILE
      end

      File.open("Gemfile.lock", "w") do |file|
        file.puts <<GEMFILE_LOCK
GEM
  remote: https://rubygems.org/
  specs:
    activemodel (4.0.0)
      activesupport (= 4.0.0)
      builder (~> 3.1.0)
    activerecord (4.0.0)
      activemodel (= 4.0.0)
      activerecord-deprecated_finders (~> 1.0.2)
      activesupport (= 4.0.0)
      arel (~> 4.0.0)
    activerecord-deprecated_finders (1.0.4)
    activesupport (4.0.0)
      i18n (~> 0.6, >= 0.6.4)
      minitest (~> 4.2)
      multi_json (~> 1.3)
      thread_safe (~> 0.1)
      tzinfo (~> 0.3.37)
    arel (4.0.2)
    builder (3.1.4)
    i18n (0.7.0)
    minitest (4.7.5)
    multi_json (1.11.2)
    thread_safe (0.3.5)
    tzinfo (0.3.44)

PLATFORMS
  ruby

DEPENDENCIES
  activerecord (= 4.0.0)
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

      output, status = Open3.capture2(BIN_PATH, "database-yml", install_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      assert_true File.exist?("#{install_path}/database.yml"), "database.yml was not written to"
    end
  end
end
