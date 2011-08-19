
require 'sinatra/base'

class ChatDemo < Sinatra::Base

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
end
