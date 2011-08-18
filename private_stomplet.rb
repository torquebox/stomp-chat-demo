
require 'torquebox-stomp'

class PrivateStomplet < TorqueBox::Stomp::JmsStomplet

  def initialize()
    super
  end

  def configure(stomplet_config)
    super
  end

  def on_message(stomp_message, session)
    username = session[:username]
    stomp_message.headers['sender'] = username
    send_to( stomp_message, '/topics/chat', :topic )
  end

  def on_subscribe(subscriber)
    username = subscriber.session[:username]
    subscribe_to( subscriber, '/topics/chat', :topic, "recipient='#{username}'" )
  end

end
