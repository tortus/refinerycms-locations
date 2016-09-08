# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-locations'
  s.version           = '1.0'
  s.description       = 'Ruby on Rails Locations extension for Refinery CMS'
  s.author            = 'Tortus Technologies'
  s.date              = '2012-05-18'
  s.summary           = 'Locations extension for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',    '~> 3'

end
