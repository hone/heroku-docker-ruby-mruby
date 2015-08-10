module CLI
  class TestDetectRuby < MTest::Unit::TestCase
    def test_simple_gemfile
      assert_equal "ruby-2.2.2", DetectRuby.new(<<GEMFILE).ruby_version.to_s
source "https://rubygems.org"

ruby "2.2.2"

gem "rails"

group :development do
  gem "rspec"
end
GEMFILE
    end
  end
end

MTest::Unit.new.run
