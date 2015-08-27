class TestGemVersion < MTest::Unit::TestCase
  def test_less_than
    assert_true Gem::Version.new("4.0.0") < Gem::Version.new("4.0.1")
    assert_true Gem::Version.new("3.9.9") < Gem::Version.new("4.0.0")
  end

  def test_greater_than
    assert_true Gem::Version.new("4.0.1") > Gem::Version.new("4.0.0")
    assert_true Gem::Version.new("4.0.0") > Gem::Version.new("3.9.9")
  end

  def test_equals
    assert_true Gem::Version.new("4.0.0") == Gem::Version.new("4.0.0")
  end

  def test_less_than_equals
    assert_true Gem::Version.new("4.0.0") <= Gem::Version.new("4.0.0")
    assert_true Gem::Version.new("4.0.0") <= Gem::Version.new("4.0.1")
  end

  def test_greater_than_equals
    assert_true Gem::Version.new("4.0.0") >= Gem::Version.new("4.0.0")
    assert_true Gem::Version.new("4.0.0") >= Gem::Version.new("3.9.9")
  end
end

MTest::Unit.new.run
