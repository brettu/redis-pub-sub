require 'redis'
require 'twilio-ruby'

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

=begin
account_sid = 'ACd60311ac8031da003b95698d1964e0d5'
auth_token = '7bfcdc5a3075af1d92f5171f5dc2ffeb'

@client = Twilio::REST::Client.new account_sid, auth_token
puts @client.account.messages.list.inspect

loop do
  @client.account.messages.list.each do |message|

    puts message.body
  end
  sleep(1)
end
=end
