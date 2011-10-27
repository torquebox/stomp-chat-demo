require 'torquebox-cache'

require 'json'

class Roster

  include TorqueBox::Injectors

  attr_accessor :members
  attr_accessor :destination

  def initialize(opts={})
    @destination = inject( '/topics/chat' )
    @cache = TorqueBox::Infinispan::Cache.new( :name => 'roster' )
  end

  def start()
  end

  def stop()
  end

  def join(username)
    m = @cache.get( 'members' ) || [] 
    m << username.to_s
    @cache.put( 'members', m )
    sleep( 2 )
  end

  def part(username)
    m = @cache.get( 'members' ) || []
    m << username.to_s
    m.delete_at(members.index(username) || m.length)
    @cache.put( 'members', m )
  end

  def members
    @cache.get( 'members' ) || []
  end

  def members_json
    members.to_json
  end

end
