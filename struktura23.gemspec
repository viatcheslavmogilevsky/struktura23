# your_library.gemspec
Gem::Specification.new do |s|
  s.name        = 'struktura23'
  s.version     = '0.0.1'
  s.date        = '2024-04-22'
  s.summary     = "Generate, query, import and manage infra with IaaC generator."
  s.description = "Longer description will be soob."
  s.authors     = ["Viacheslav Mogilevskii"]
  s.email       = 'idontcare@example.com'
  s.files       = Dir["lib/**/*.rb"]
  s.homepage    = 'https://example.com/idontcare'
  s.license     = 'MIT'

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
