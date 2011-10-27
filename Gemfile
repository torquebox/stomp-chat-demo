
gem_version = "~> 2.x.incremental"

if ( ENV['TORQUEBOX_STAGING'] )
  source "file://#{ENV['TORQUEBOX_STAGING']}/gem-repo" 
  gem_version = '2.0.0'
end

source "http://torquebox.org/2x/builds/LATEST/gem-repo/"
source :rubygems

gem 'sinatra'
gem "haml"

gem "jruby-openssl"
gem "torquebox",              gem_version
gem "torquebox-rake-support", gem_version
gem "torquebox-messaging",    gem_version
gem "torquebox-stomp",        gem_version
gem "torquebox-web",          gem_version
gem "torquebox-cache",        gem_version
gem "json"
gem 'mdp', :git => 'https://github.com/sundbp/mdp.git'
