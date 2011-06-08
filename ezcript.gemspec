require File.dirname(__FILE__) + "/lib/ezcript/version"

Gem::Specification.new do |s|
  s.name        = "Ezcript"
  s.version     = Ezcript::VERSION::STRING
  s.author      = ["Melvin Sembrano"]
  s.email       = ["melvinsembrano@gmail.com"]
  s.homepage    = "http://github.com/melvinsembrano/ezcript"
  s.license     = 'MIT'
  s.description = ""  # Please fill in a short description
  s.summary     = ""  # Please fill in a longer summary

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.md", "CHANGELOG.md"]

  # s.add_dependency('other_gem', ">= version")

  s.add_development_dependency("rspec", ">= 2.5.1")
  s.add_development_dependency("ZenTest", ">= 4.5.0")
  s.add_development_dependency("rake", ">= 0.8.7")
  s.add_development_dependency("bundler", ">= 1.0.12")
  s.add_development_dependency("jsmin", ">= 1.0.1")

  s.require_path = 'lib'
  s.files = %w(README.md Rakefile) + Dir.glob("lib/**/*")
end
