require 'redis'

redis = Redis.new

class Subscriber
  attr_reader :channels
  attr_reader :redis

  def initialize(redis, *channels)
    @redis = redis
    @channels = channels
  end

  def start!
    check_queue
    listen
  end

  def check_queue
    channels.each do |channel|
      until(message = redis.lpop(channel)) == nil
        handle_message(channel, message)
      end
    end
  end

  def handle_message(channel, message)
    puts "##{channel}: #{message}"
  end

  def Subscribe
    redis.subscribe(:odd, :even) do |on|
      on.subscribe do |channel|
        puts "Subscribed to ##{channel}."
      end

      on.message do |message|
        handle_message(channel, message)
      end
    end
  end
end

Subscriber.new(redis, :odd, :even).start!
