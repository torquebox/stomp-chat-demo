
require 'sinatra/base'

class ChatDemo < Sinatra::Base

  get '/' do
    haml :login
  end
  
  post '/' do
    session[:username] = params[:username]
    redirect to( '/chat' )
  end
  

  get '/chat' do
    haml :chat 
  end
end
