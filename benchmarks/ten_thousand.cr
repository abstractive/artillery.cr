require "http/client"

total_requests = 10_000

puts "Starting test, with #{total_requests} requests."
puts "Make sure a Mountpoint and Launcher are online..."

start = Time.now
i = 0

total_requests.times {  
  break unless HTTP::Client.get("http://localhost:3000").status_code == 200
  i += 1
  Fiber.yield
}

seconds = (Time.now - start).total_seconds
puts "Messages per second: #{(i * 2) / seconds.to_f}"
puts "Total seconds: #{seconds}"