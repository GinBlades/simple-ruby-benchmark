require "benchmark"
require "net/http"
require "uri"
require "json"

Benchmark.bm do |x|
  x.report("Creating records") do
    100.times do |i|
      uri = URI.parse("http://localhost:4567")
      header = { "Content-Type": "text/json" }
      item = {
        "name": "New Item #{i}",
        "price": rand * 100 + i,
        "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Dolorem ducimus, dolore est porro, debitis aspernatur sequi. Tempora, minus, omnis, quos quasi iste excepturi tenetur ab libero animi fuga itaque non."
      }

      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = item.to_json

      response = http.request(request)
      throw "Invalid response code: #{response.code}" if response.code.to_i != 200
    end
  end
end
