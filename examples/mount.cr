require "zeromq"

context = ZMQ::Context.new
server = context.socket(ZMQ::REP)
server.bind("tcp://127.0.0.1:5555")

puts "Start mount example."

loop do
    puts server.receive_string
    server.send_string("Got it")
end