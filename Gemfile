
torquebox_version = 340
gem_version = "2.x.incremental.#{torquebox_version}"

if ( ENV['TORQUEBOX_STAGING'] ) 
  source "file://#{ENV['TORQUEBOX_STAGING']}/gem-repo" 
  gem_version = '2.0.0'
end

source "http://torquebox.org/2x/builds/#{torquebox_version}/gem-repo/"



source :rubygems

gem 'sinatra'
gem "haml"

gem "jruby-openssl"
gem "torquebox",              gem_version
gem "torquebox-rake-support", gem_version
gem "torquebox-messaging",    gem_version
gem "torquebox-stomp",        gem_version
gem "torquebox-web",          gem_version
gem "json"



