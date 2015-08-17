def gem_config(conf)
  #conf.gembox 'default'

  # be sure to include this gem (the cli app)
  conf.gem File.expand_path(File.dirname(__FILE__))
end

MRuby::Build.new do |conf|
  toolchain :clang

  conf.enable_bintest
  conf.enable_debug

  gem_config(conf)
end

MRuby::CrossBuild.new('x86_64-pc-linux-gnu') do |conf|
  toolchain :clang

  [conf.cc, conf.cxx, conf.linker].each do |cc|
    cc.flags << "-static"
  end

  conf.build_mrbtest_lib_only

  gem_config(conf)
end
