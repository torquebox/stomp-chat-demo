
require 'torquebox-stomp'

class PublicStomplet < TorqueBox::Stomp::JmsStomplet

  include TorqueBox::Injectors

  def initialize()
    super
    @destination = inject( '/topics/chat' )
  end

  def on_message(stomp_message, session)
    username = session[:username]
    stomp_message.headers['sender'] = username
    stomp_message.headers['recipient'] = 'public'
    send_to( @destination, stomp_message )
  end

  def on_subscribe(subscriber)
    username = subscriber.session[:username]
    subscribe_to( subscriber,  
                  @destination,  
                  "recipient='public'" )
    update_roster :join, username
  end

  def on_unsubscribe(subscriber)
    username = subscriber.session[:username]
    update_roster :part, username
    super
  end

  private

  def update_roster(action, username)
    send_to( @destination, 
             "#{action}: #{username}",
             :roster=>action,
             :username=>username, 
             :sender=>:system, 
             :recipient=>:public )
  end

end
