require "benchmark"
require "await_async"
require "http"

#de TODO: Fix the self-signed certificate failures going on.

def fetch_websites_async
  %w[
    abstractive.zero
    cornerstone.zero
    daykeeper.zero
    delimiter.zero
    digitalextremist.zero
    freed.zero
    paraclete.zero
    proactive.zero
    revamper.zero
  ].map do |url|
    async! do
      length = Benchmark.measure {
        HTTP::Client.get "https://#{url}/test"
      }
      {
        speed: length,
        fqdn: url 
      }
    end
  end
end

await(5.seconds, fetch_websites_async).each do |response|
  puts "URL: #{response[:fqdn]} // #{response[:speed]}"
end