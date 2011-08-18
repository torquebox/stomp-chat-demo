
require 'torquebox-stomp'
require 'json'

class PublicStomplet < TorqueBox::Stomp::JmsStomplet

  def initialize()
    super
    @roster = []
  end

  def configure(stomplet_config)
    super
  end

  def on_message(stomp_message, session)
    username = session[:username]
    puts "username is #{username}"
    puts "headers are #{stomp_message.headers.class}"
    #stomp_message.headers['sender'] = username
    stomp_message.headers['recipient'] = 'public'
    send_to( stomp_message, '/topics/chat', :topic )
  end

  def on_subscribe(subscriber)
    subscribe_to( subscriber, '/topics/chat', :topic, "recipient='public'" )
    #subscribe_to( subscriber, '/topics/chat', :topic )

    username = subscriber.session[:username]
    ( @roster << username ) unless @roster.include?( username )

    announcement = org.projectodd.stilts.stomp::StompMessages.createStompMessage( '/topics/chat', "#{username} joined" )
    announcement.headers['sender'] = 'system'
    announcement.headers['recipient'] = 'public'

    send_to( announcement, '/topics/chat', :topic )

    roster_json = @roster.to_json
    roster = org.projectodd.stilts.stomp::StompMessages.createStompMessage( '/topics/chat', roster_json )
    roster.headers['sender'] = 'system'
    roster.headers['roster'] = 'true'
    roster.headers['recipient'] = 'public'

    send_to( roster, '/topics/chat', :topic )
  end


end
