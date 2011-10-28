require 'torquebox-cache'

class Roster

  include TorqueBox::Injectors

  def initialize(opts={})
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
    puts "JOIN #{username}: now #{@cache.get( 'members' ).inspect}"
  end

  def part(username)
    m = @cache.get( 'members' ) || []
    m << username.to_s
    m.delete_at(members.index(username) || m.length)
    @cache.put( 'members', m )
    sleep(2)
    puts "PART #{username}: now #{@cache.get( 'members' ).inspect}"
  end

  def members
    @cache.get( 'members' ) || []
  end

  def to_json
    result = '[' + self.members.collect{|e| "\"#{e}\"" }.join( ', ' ) + ']'
    puts "result #{result}"
    result
  end

end
