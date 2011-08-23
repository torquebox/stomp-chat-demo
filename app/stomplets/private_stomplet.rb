
require 'torquebox-stomp'

class PrivateStomplet < TorqueBox::Stomp::JmsStomplet

  include TorqueBox::Injectors

  def initialize()
    super
    @destination = inject( '/topics/chat' )
  end

  def on_message(stomp_message, session)
    username = session[:username]
    stomp_message.headers['sender'] = username
    send_to( @destination, stomp_message )
  end

  def on_subscribe(subscriber)
    username = subscriber.session[:username]
    subscribe_to( subscriber, 
                  @destination, 
                  "recipient='#{username}' OR ( sender='#{username}' AND NOT recipient='public')" )
  end

end
