
require 'sinatra/base'
include TorqueBox::Injectors

class ChatDemo < Sinatra::Base

  helpers TorqueBox::Injectors

  get '/' do
    haml :login
  end
  
  post '/' do
    username = params[:username]
    redirect to( '/' ) and return if username.nil?
    username.strip!
    redirect to( '/' ) and return if ( username == '' )
    redirect to( '/' ) and return if ( ! ( username =~ /^[a-zA-Z0-9_]+$/ ) )

    session[:username] = username
    haml :chat 
  end

  get '/profile/:username' do
    username = params[:username]
    message = "#{username}, someone from #{env['REMOTE_ADDR']} checked out your profile"
    __inject__( '/topics/chat' ).publish( message, :properties=>{ :recipient=>username, :sender=>'system' } )
    haml :profile
  end
end
