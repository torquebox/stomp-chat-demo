
require 'torquebox-stomp'
require 'json'

class PublicStomplet < TorqueBox::Stomp::JmsStomplet

  def initialize()
    super
    @lock = Mutex.new  
    @roster = []
  end

  def configure(stomplet_config)
    super
  end

  def on_message(stomp_message, session)
    username = session[:username]
    stomp_message.headers['sender'] = username
    stomp_message.headers['recipient'] = 'public'
    send_to( stomp_message, '/topics/chat', :topic )
  end

  def on_subscribe(subscriber)
    username = subscriber.session[:username]

    subscribe_to( subscriber, '/topics/chat', :topic, "recipient='public'" )

    announcement = org.projectodd.stilts.stomp::StompMessages.createStompMessage( '/public', "#{username} joined" )
    announcement.headers['sender'] = 'system'
    announcement.headers['recipient'] = 'public'
    send_to( announcement, '/topics/chat', :topic )

    @lock.synchronize {
      @roster << username 
      send_roster()
    }
  end

  def on_unsubscribe(subscriber)
    username = subscriber.session[:username]
    @lock.synchronize {
      @roster.delete_at(@roster.index(username) || @roster.length)
      send_roster()
    }
    super

    announcement = org.projectodd.stilts.stomp::StompMessages.createStompMessage( '/public', "#{username} left" )
    announcement.headers['sender'] = 'system'
    announcement.headers['recipient'] = 'public'
    send_to( announcement, '/topics/chat', :topic )
  end

  def send_roster()
    roster_json = @roster.uniq.to_json
    roster = org.projectodd.stilts.stomp::StompMessages.createStompMessage( '/topics/chat', roster_json )
    roster.headers['sender'] = 'system'
    roster.headers['roster'] = 'true'
    roster.headers['recipient'] = 'public'

    send_to( roster, '/topics/chat', :topic )
  end



end
