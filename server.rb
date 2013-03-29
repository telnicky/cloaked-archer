require 'em-websocket'
require 'pry'
#
# HTTP/1.1 101 Switching Protocols
# Upgrade: websocket
# Connection: Upgrade
# Sec-WebSocket-Accept: HSmrc0sMlYUkAGmm5OPpG2HaGWk=
# Sec-WebSocket-Protocol: chat\
sockets = []

EM.run {
  EM::WebSocket.run(:host => "127.0.0.1", :port => 8080) do |ws|

sockets << ws

    ws.onopen { |handshake|
binding.pry
      puts "WebSocket connection open"
      # Access properties on the EM::WebSocket::Handshake object, e.g.
      # path, query_string, origin, headers

      # Publish message to the client
      ws.send "Hello Client, you connected to #{handshake.path}"
    }

    ws.onclose { puts "Connection closed" }

    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"
      sockets.each do |s|
        s.send "Ponggggg: #{msg}"
      end
    }
  end
}