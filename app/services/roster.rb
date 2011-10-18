require 'json'

class Roster

  attr_accessor :members

  def initialize(opts={})
  end

  def start()
    puts "START roster"
    @members = []
  end

  def stop()
    @members = []
  end

  def join(username)
    @members << username.to_s
  end

  def part(username)
    @members.delete_at(@roster.index(username) || @roster.length)
  end

  def to_json
    puts "JSON #{@members.inspect}"
    json = @members.to_json
    puts "JSON=#{json}"
    json.to_s
  end
end
