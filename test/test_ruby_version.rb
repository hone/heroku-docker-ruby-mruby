class TestRubyVersion < MTest::Unit::TestCase
  def test_to_s
    assert_equal "ruby-2.2.2", RubyVersion.new("2.2.2").to_s
    assert_equal "ruby-2.0.0-p645", RubyVersion.new("2.0.0", "645").to_s
    assert_equal "ruby-1.9.3-jruby-1.7.21", RubyVersion.new("1.9.3", nil, "jruby", "1.7.21").to_s
  end
end

MTest::Unit.new.run
