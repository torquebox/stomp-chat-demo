
require 'torquebox-stomp'
require 'json'

class PublicStomplet < TorqueBox::Stomp::JmsStomplet

  include TorqueBox::Injectors

  def initialize()
    super
    @destination = inject( '/topics/chat' )
    @lock = Mutex.new  
    @roster = []
  end

  def on_message(stomp_message, session)
    username = session[:username]
    stomp_message.headers['sender'] = username
    stomp_message.headers['recipient'] = 'public'
    send_to( @destination, stomp_message )
  end

  def on_subscribe(subscriber)
    username = subscriber.session[:username]

    subscribe_to( subscriber, @destination, "recipient='public'" )
    update_roster :add=>username
    send_to( @destination, "#{username} joined", :sender=>:system, :recipient=>:public )
  end

  def on_unsubscribe(subscriber)
    username = subscriber.session[:username]

    update_roster :remove=>username
    super
    send_to( @destination, "#{username} left", :sender=>:system, :recipient=>:public )
  end

  private

  def update_roster(changes={})
    @lock.synchronize do
      [ (changes[:remove] || []) ].flatten.each do |username|
        @roster.delete_at(@roster.index(username) || @roster.length)
      end
      [ (changes[:add] || []) ].flatten.each do |username|
        @roster << username
      end
      send_to( @destination, @roster.uniq.to_json, :sender=>:system, :recipient=>:public, :roster=>true )
    end
  end

end
