module CLI
  class TestInstallRuby < MTest::Unit::TestCase
    def test_run
      output       = StringIO.new
      install_path = "/tmp/ruby-#{rand(Time.now.usec).to_s(36)}"
      InstallRuby.new(output).run(<<GEMFILE, install_path)
ruby "2.2.2"
GEMFILE
      assert Dir.exist?("#{install_path}/ruby-2.2.2")
    end

    def test_run_install_path_extra_trailing_slash
      output       = StringIO.new
      install_path = "/tmp/ruby-#{rand(Time.now.usec).to_s(36)}/"
      InstallRuby.new(output).run(<<GEMFILE, install_path)
ruby "2.2.2"
GEMFILE
      assert Dir.exist?("#{install_path}/ruby-2.2.2")
    end
  end
end

MTest::Unit.new.run
