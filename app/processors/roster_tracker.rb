
class RosterTracker < TorqueBox::Messaging::MessageProcessor

  include TorqueBox::Injectors

  attr_accessor :destination

  def initialize()
    @destination = inject( '/topics/chat' )
    @roster = inject( 'service:roster' )
  end

  def on_message(body)
    puts "RECEIVE: #{body}"

    action   = message.getStringProperty( 'roster' )
    username = message.getStringProperty( 'username' )
    if ( action == 'join' )
      join( username )
    elsif ( action == 'part' )
      part( username )
    end
    distribute_roster()
  end

  def join(username)
    @roster.join( username )
  end

  def part(username)
    @roster.part( username )
  end

  def distribute_roster()
    @destination.publish(
      @roster.to_json,
      :encoding=>:text,
      :properties => {
        :sender=>'system',
        :recipient=>'public',
        :roster=>'update',
      }
    )
  end

end
