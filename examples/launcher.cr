require "zeromq"

context = ZMQ::Context.new
client = context.socket(ZMQ::REQ)
client.connect("tcp://127.0.0.1:5555")

puts "Start launcher example."

loop do
  client.send_string("READY")
  puts "#{Time.now}: " + client.receive_string
end