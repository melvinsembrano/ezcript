begin
  require "rubygems"
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("1.0.0")
  raise RuntimeError, "Your bundler version is too old for Mail" +
   "Run `gem install bundler` to upgrade."
end

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../Gemfile", __FILE__)
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

require "ezcript/version"

task :build do
  system "gem build ezcript.gemspec"
end

task :release => :build do
  system "gem push ezcript-#{Ezcript::VERSION::STRING}"
end
