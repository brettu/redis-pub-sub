require 'redis'


redis = Redis.new

i = 0
loop do

  queue = i.even? ? :even : :odd
  result = redis.publish(queue, i)
  if result == 1
    puts "Published [##{queue} #{i}]"
  else
    redis.rpush(queue, i)
  end

  i += 1
  sleep(1)
end
