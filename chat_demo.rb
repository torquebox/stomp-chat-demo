
require 'sinatra/base'

class ChatDemo < Sinatra::Base

  helpers TorqueBox::Injectors
  
  helpers do
    def content_for(key, &block)
      @content ||= {}
      @content[key] = capture_haml(&block)
    end
    def content(key)
      @content && @content[key]
    end

    def stomp_url
      inject( 'stomp-endpoint' )
    end
  end  

  get '/' do
    session[:start] = 'hi'
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
    inject( '/topics/chat' ).publish( message, :properties=>{ :recipient=>username, :sender=>'system' } )
    haml :profile
  end
end
