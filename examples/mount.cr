require "../src/artillery/mount"

context = ZMQ::Context.new
server = context.socket(ZMQ::REP)
server.bind("tcp://127.0.0.1:5555")

puts "Start mount example."

get "/" do |env|
  puts "#{Time.now}: " + server.receive_string
  server.send_string("Hello World")
  "Hello World!"
end

Kemal.run