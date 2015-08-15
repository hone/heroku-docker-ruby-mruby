require 'open3'
require 'tmpdir'

BIN_PATH = File.join(File.dirname(__FILE__), "../mruby/bin/heroku-docker-ruby-mruby")

assert('command not found') do
  output, error, status = Open3.capture3(BIN_PATH, "foo")
  assert_include error, "foo not a valid command"
end

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
      install_path  = "ruby"
      profiled_path = ".profile.d/ruby.sh"

      output, status = Open3.capture2(BIN_PATH, "install-ruby", "Gemfile", install_path, profiled_path)

      assert_true status.success?, "Process did not exit cleanly"
      assert_true Dir.exist?("#{install_path}/ruby-2.2.2")
      assert_true File.exist?(profiled_path)
      assert_include `bash -c "source #{profiled_path} && ruby -v"`, "ruby 2.2.2"
    end
  end
end

assert('install-node') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      install_path  = "ruby"
      profiled_path = ".profile.d/ruby.sh"

      output, status = Open3.capture2(BIN_PATH, "install-node", "0.12.7", install_path, profiled_path)

      assert_true status.success?, "Process did not exit cleanly"
      assert_true Dir.exist?("#{install_path}/node-0.12.7")
      assert_true File.exist?(profiled_path)
      assert_include `bash -c "source #{profiled_path} && node -v"`, "v0.12.7"
    end
  end
end

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
      profiled_path = ".profile.d/ruby.sh"

      output, status = Open3.capture2(BIN_PATH, "install-ruby", "Gemfile", install_path, profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      output, status = Open3.capture2(BIN_PATH, "install-bundler", "1.9.7", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"
      assert_true File.exist?("ruby/bundle/ruby/2.2.0/gems/bundler-1.9.7/"), "Could not find bundler gem"

      output, status = Open3.capture2(%Q{bash -c "source #{profiled_path} && bundle -v"})
      assert_true status.success?, "bundler did not exit cleanly"
      assert_include output, "1.9.7"
    end
  end
end

assert('bundle-install') do
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

      output, status = Open3.capture2(BIN_PATH, "install-bundler", "1.9.7", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      output, status = Open3.capture2(BIN_PATH, "bundle-install", "#{install_path}/bundle", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      output, status = Open3.capture2(%Q{bash -c "source #{profiled_path} && bundle exec rackup --version"})
      assert_true status.success?, "Process did not exit cleanly"
      assert_include output, "1.6.4"
    end
  end
end

assert('rails-env') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      profiled_path = ".profile.d/ruby.sh"
      output, status = Open3.capture2(BIN_PATH, "rails-env", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      output, status = Open3.capture2(%Q{bash -c "source #{profiled_path} && env"})
      assert_include output, "RAILS_ENV=production"
      assert_include output, "SECRET_KEY_BASE"

      output, status = Open3.capture2(%Q{RAILS_ENV=staging SECRET_KEY_BASE=secret bash -c "source #{profiled_path} && env"})
      assert_include output, "RAILS_ENV=staging"
      assert_include output, "SECRET_KEY_BASE=secret"
    end
  end
end
