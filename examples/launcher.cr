require "zeromq"

context = ZMQ::Context.new
client = context.socket(ZMQ::REQ)
client.connect("tcp://127.0.0.1:5555")

puts "Start launcher example."

client.send_string("Fetch")
puts client.receive_string