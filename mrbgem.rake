MRuby::Gem::Specification.new('heroku-docker-ruby-mruby') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Terence'
  spec.summary = 'heroku-docker-ruby-mruby'
  spec.bins    = ['heroku-docker-ruby-mruby']

  spec.add_dependency 'mruby-eval',      core: 'mruby-eval'
  spec.add_dependency 'mruby-array-ext', core: 'mruby-array-ext'
  spec.add_dependency 'mruby-io',        mgem: 'mruby-io'
  spec.add_dependency 'mruby-dir',       mgem: 'mruby-dir'

  # test deps
  spec.add_dependency 'mruby-time',      core: 'mruby-time'
  spec.add_dependency 'mruby-random',    core: 'mruby-random'
  spec.add_dependency 'mruby-mtest',     mgem: 'mruby-mtest'
  spec.add_dependency 'mruby-stringio',  github: 'ksss/mruby-stringio'
end
