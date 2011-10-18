require 'json'

class RosterTracker < TorqueBox::Messaging::MessageProcessor

  include TorqueBox::Injectors

  def initialize()
    @roster = inject('service:roster' )
    @dest   = inject('/topics/chat' )
  end

  def on_message(body)
    action   = message.getStringProperty( 'roster' )
    username = message.getStringProperty( 'username' )
    puts "received #{message} #{action} #{username}"
    if ( action == 'join' )
      @roster.join( username )
      distribute_roster()
    elsif ( action == 'part' )
      @roster.part( username )
      distribute_roster()
    end
  end

  def distribute_roster()
    puts "sending out #{@roster.members.inspect}"
    r = @roster.members.collect{|e| e}
    @dest.publish(
      r.to_json,
      :encoding=>:text,
      :properties => {
        :sender=>'system',
        :recipient=>'public',
        :roster=>'update',
      }
    )
  end

end
