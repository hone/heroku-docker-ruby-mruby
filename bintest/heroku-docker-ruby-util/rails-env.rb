require 'open3'
require 'tmpdir'
require_relative '../support/paths'

assert('rails-env without rails 4.1') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.3"

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

      output, status = Open3.capture2(BIN_PATH, "rails-env", profiled_path)
      assert_true status.success?, "Process did not exit cleanly"

      output, status = Open3.capture2(%Q{bash -c "source #{profiled_path} && env"})
      assert_not_include output, "RAILS_ENV=production"
      assert_not_include output, "SECRET_KEY_BASE"
    end
  end
end

assert('rails-env with rails 4.1') do
  Dir.mktmpdir do |tmp_dir|
    Dir.chdir(tmp_dir) do
      File.open("Gemfile", "w") do |file|
        file.puts <<GEMFILE
source "https://rubygems.org"

ruby "2.2.3"

gem "rails"
GEMFILE
      end

      File.open("Gemfile.lock", "w") do |file|
        file.puts <<GEMFILE_LOCK
GEM
  remote: https://rubygems.org/
  specs:
    actionmailer (4.2.4)
      actionpack (= 4.2.4)
      actionview (= 4.2.4)
      activejob (= 4.2.4)
      mail (~> 2.5, >= 2.5.4)
      rails-dom-testing (~> 1.0, >= 1.0.5)
    actionpack (4.2.4)
      actionview (= 4.2.4)
      activesupport (= 4.2.4)
      rack (~> 1.6)
      rack-test (~> 0.6.2)
      rails-dom-testing (~> 1.0, >= 1.0.5)
      rails-html-sanitizer (~> 1.0, >= 1.0.2)
    actionview (4.2.4)
      activesupport (= 4.2.4)
      builder (~> 3.1)
      erubis (~> 2.7.0)
      rails-dom-testing (~> 1.0, >= 1.0.5)
      rails-html-sanitizer (~> 1.0, >= 1.0.2)
    activejob (4.2.4)
      activesupport (= 4.2.4)
      globalid (>= 0.3.0)
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
    erubis (2.7.0)
    globalid (0.3.6)
      activesupport (>= 4.1.0)
    i18n (0.7.0)
    json (1.8.3)
    loofah (2.0.3)
      nokogiri (>= 1.5.9)
    mail (2.6.3)
      mime-types (>= 1.16, < 3)
    mime-types (2.6.1)
    mini_portile (0.6.2)
    minitest (5.8.0)
    nokogiri (1.6.6.2)
      mini_portile (~> 0.6.0)
    rack (1.6.4)
    rack-test (0.6.3)
      rack (>= 1.0)
    rails (4.2.4)
      actionmailer (= 4.2.4)
      actionpack (= 4.2.4)
      actionview (= 4.2.4)
      activejob (= 4.2.4)
      activemodel (= 4.2.4)
      activerecord (= 4.2.4)
      activesupport (= 4.2.4)
      bundler (>= 1.3.0, < 2.0)
      railties (= 4.2.4)
      sprockets-rails
    rails-deprecated_sanitizer (1.0.3)
      activesupport (>= 4.2.0.alpha)
    rails-dom-testing (1.0.7)
      activesupport (>= 4.2.0.beta, < 5.0)
      nokogiri (~> 1.6.0)
      rails-deprecated_sanitizer (>= 1.0.1)
    rails-html-sanitizer (1.0.2)
      loofah (~> 2.0)
    railties (4.2.4)
      actionpack (= 4.2.4)
      activesupport (= 4.2.4)
      rake (>= 0.8.7)
      thor (>= 0.18.1, < 2.0)
    rake (10.4.2)
    sprockets (3.3.3)
      rack (~> 1.0)
    sprockets-rails (2.3.2)
      actionpack (>= 3.0)
      activesupport (>= 3.0)
      sprockets (>= 2.8, < 4.0)
    thor (0.19.1)
    thread_safe (0.3.5)
    tzinfo (1.2.2)
      thread_safe (~> 0.1)

PLATFORMS
  ruby

DEPENDENCIES
  rails
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
