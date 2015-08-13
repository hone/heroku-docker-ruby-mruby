module CLI
  class TestInstallRuby < MTest::Unit::TestCase
    def test_run
      output        = StringIO.new
      install_path  = "/tmp/ruby-#{rand(Time.now.usec).to_s(36)}"
      profiled_path = "#{install_path}/.profile.d/ruby.sh"
      InstallRuby.new(output).run(<<GEMFILE, install_path, profiled_path)
ruby "2.2.2"
GEMFILE
      assert_include output.string, "ruby-2.2.2"
      assert Dir.exist?("#{install_path}/ruby-2.2.2")
      assert File.exist?(profiled_path)
      assert_include File.read(profiled_path), %Q{export PATH="#{install_path}/ruby-2.2.2/bin:$PATH"}
      assert_include File.read(profiled_path), %Q{export GEM_PATH="#{install_path}/bundle/ruby/2.2.0"}
      assert_include File.read(profiled_path), %Q{export GEM_HOME="#{install_path}/bundle/ruby/2.2.0"}
    ensure
      IO.popen("rm -rf #{install_path}")
    end

    def test_run_install_path_extra_trailing_slash
      output       = StringIO.new
      install_path = "/tmp/ruby-#{rand(Time.now.usec).to_s(36)}/"
      InstallRuby.new(output).run(<<GEMFILE, install_path)
ruby "2.2.2"

GEMFILE
      assert_include output.string, "ruby-2.2.2"
      assert Dir.exist?("#{install_path}/ruby-2.2.2")
    ensure
      IO.popen("rm -rf #{install_path}")
    end
  end
end

MTest::Unit.new.run
