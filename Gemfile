source :rubygems

# Add your run time dependencies here
gem "jsmin"

group :test do
  gem "ZenTest"
  gem "rake"
  gem "bundler"
  gem "rspec"
  gem "diff-lcs"

  case
  when defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
    # Skip it
  when RUBY_PLATFORM == 'java'
    # Skip it
  when RUBY_VERSION < '1.9'
    gem "ruby-debug"
  else
    # Skip it
  end
end
