require "crest"
require "await_async"

TOTAL_REQUESTS = 10_000

puts "Starting test, with #{TOTAL_REQUESTS} requests."

start = Time.local

def benchmark
  TOTAL_REQUESTS.times.map {
      async! {
        Crest.get(
        "https://abstractive.zero/test",
        tls: OpenSSL::SSL::Context::Client.insecure
      )
    }
  }
end

await(5.seconds, benchmark).each {
  printf "."
}

seconds = (Time.local - start).total_seconds
puts "Messages per second: #{TOTAL_REQUESTS / seconds}"
puts "Total seconds: #{seconds}"