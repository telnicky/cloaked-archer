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
      puts "Connecting... "
      # Access properties on the EM::WebSocket::Handshake object, e.g.
      # path, query_string, origin, headers

      # Publish message to the client
      ws.send "Connecting... #{handshake.path}"
    }

    ws.onclose { puts "Connection closed" }

    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"

      sockets.each do |s|
        s.send "to everyone but sender: #{msg}" unless s.signature == ws.signature
      end
    }
  end
}