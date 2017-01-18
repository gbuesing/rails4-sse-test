class SseController < ApplicationController
  include ActionController::Live

  def sse
    puts "Request started at #{Time.now} in #{Thread.current}"
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Cache-Control'] = 'no-cache'

    sse = SSE.new(response.stream, event: "test")

    10.times do |i|
      sse.write message: "hello world #{i}"
      puts "sse #{i}"
      sleep 1
    end
  ensure
    sse.close
  end
end
