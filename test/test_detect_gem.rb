module CLI
  class TestDetectGem < MTest::Unit::TestCase
    def test_gemspec_file
      gem_setup do |profiled_path, specs_dir|
        assert_equal "actionmailer-4.2.0.gemspec", DetectGem.new(profiled_path).gemspec_file("actionmailer")
      end
    end

    def test_gem
      gem_setup do |profiled_path, specs_dir|
        assert_equal "4.2.0", DetectGem.new(profiled_path).gem("actionmailer")
      end
    end

    def test_no_gem
      gem_setup do |profiled_path, specs_dir|
        assert_nil DetectGem.new(profiled_path).gem("foo")
      end
    end

    private
    def gem_setup
      workdir       = "/tmp/ruby-#{rand(Time.now.usec).to_s(36)}"
      profiled_path = "#{workdir}/ruby.sh"
      specs_dir     = "#{workdir}/specifications"
      Util.mkdir_p(specs_dir)
      File.open(profiled_path, "w") do |file|
        file.puts %Q{export GEM_HOME="#{workdir}"}
      end
      File.open("#{specs_dir}/actionmailer-4.2.0.gemspec", "w") do |file|
        file.puts <<GEMSPEC
# -*- encoding: utf-8 -*-
# stub: actionmailer 4.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "actionmailer"
  s.version = "4.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["David Heinemeier Hansson"]
  s.date = "2014-12-20"
  s.description = "Email on Rails. Compose, deliver, receive, and test emails using the familiar controller/view pattern. First-class support for multipart email and attachments."
  s.email = "david@loudthinking.com"
  s.homepage = "http://www.rubyonrails.org"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.requirements = ["none"]
  s.rubygems_version = "2.4.5.1"
  s.summary = "Email composition, delivery, and receiving framework (part of Rails)."

  s.installed_by_version = "2.4.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<actionpack>, ["= 4.2.0"])
      s.add_runtime_dependency(%q<actionview>, ["= 4.2.0"])
      s.add_runtime_dependency(%q<activejob>, ["= 4.2.0"])
      s.add_runtime_dependency(%q<mail>, [">= 2.5.4", "~> 2.5"])
      s.add_runtime_dependency(%q<rails-dom-testing>, [">= 1.0.5", "~> 1.0"])
    else
      s.add_dependency(%q<actionpack>, ["= 4.2.0"])
      s.add_dependency(%q<actionview>, ["= 4.2.0"])
      s.add_dependency(%q<activejob>, ["= 4.2.0"])
      s.add_dependency(%q<mail>, [">= 2.5.4", "~> 2.5"])
      s.add_dependency(%q<rails-dom-testing>, [">= 1.0.5", "~> 1.0"])
    end
  else
    s.add_dependency(%q<actionpack>, ["= 4.2.0"])
    s.add_dependency(%q<actionview>, ["= 4.2.0"])
    s.add_dependency(%q<activejob>, ["= 4.2.0"])
    s.add_dependency(%q<mail>, [">= 2.5.4", "~> 2.5"])
    s.add_dependency(%q<rails-dom-testing>, [">= 1.0.5", "~> 1.0"])
  end
end
GEMSPEC
      end

      yield(profiled_path, specs_dir)
    ensure
      IO.popen("rm -rf #{workdir}")
    end
  end
end

MTest::Unit.new.run
