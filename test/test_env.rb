module CLI
  class TestEnv < MTest::Unit::TestCase
    def test_initialize
      profiled_path  = "/tmp/ruby-#{rand(Time.now.usec).to_s(36)}/ruby.sh"
      Util.mkdir_p(File.dirname(profiled_path))

      File.open(profiled_path, 'w') do |file|
        file.puts <<PROFILED
export FOO=foo
export BAR="bar"
PROFILED
      end

      env = Env.new(profiled_path)
      assert_equal "foo", env["FOO"]
      assert_equal "bar", env["BAR"]
    ensure
      IO.popen("rm -rf #{File.dirname(profiled_path)}")
    end
  end
end

MTest::Unit.new.run
