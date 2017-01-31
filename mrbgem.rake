MRuby::Gem::Specification.new('heroku-docker-ruby-util') do |spec|
  spec.license = 'MIT'
  spec.author  = 'Terence'
  spec.summary = 'heroku-docker-ruby-util'
  spec.bins    = ['heroku-docker-ruby-util']

  spec.add_dependency 'mruby-eval',        core: 'mruby-eval'
  spec.add_dependency 'mruby-array-ext',   core: 'mruby-array-ext'
  spec.add_dependency 'mruby-dir',         mgem: 'mruby-dir'
  spec.add_dependency 'mruby-env',         mgem: 'mruby-env'
  spec.add_dependency 'mruby-onig-regexp', mgem: 'mruby-onig-regexp'
  spec.add_dependency 'mruby-stringio',    github: 'ksss/mruby-stringio'
  spec.add_dependency 'mruby-process',     github: 'hone/mruby-process',    branch: 'header'
  spec.add_dependency 'mruby-io',          github: 'hone/mruby-io',         branch: 'popen_status'
  spec.add_dependency 'mruby-docopt',      github: 'hone/mruby-docopt',     branch: 'rust'

  # test deps
  spec.add_dependency 'mruby-time',        core: 'mruby-time'
  spec.add_dependency 'mruby-random',      core: 'mruby-random'
  spec.add_dependency 'mruby-mtest',       mgem: 'mruby-mtest'
end
