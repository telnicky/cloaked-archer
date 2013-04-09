require 'em-websocket'
require 'pry'
require 'json'
#
# HTTP/1.1 101 Switching Protocols
# Upgrade: websocket
# Connection: Upgrade
# Sec-WebSocket-Accept: HSmrc0sMlYUkAGmm5OPpG2HaGWk=
# Sec-WebSocket-Protocol: chat\
sockets = []

EM.run {
  EM::WebSocket.run(:host => "ec2-54-225-88-70.compute-1.amazonaws.com", :port => 8080) do |ws|

    sockets << ws

    ws.onopen { |handshake|
      puts "Connecting... "
      # Access properties on the EM::WebSocket::Handshake object, e.g.
      # path, query_string, origin, headers

      # Publish message to the client

      ws.send({:id => ws.signature, :pos => [42,20], :on_open => true}.to_json)

    }

    ws.onclose { 
      puts "Connection closed" 
      sockets.reject! {|socket| socket.signature == ws.signature}
      sockets.each do |s|
        s.send({:id => ws.signature, :pos => [42,20], :on_close => true}.to_json)        
      end
    }

    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"

      sockets.each do |s|
        s.send msg unless s.signature == ws.signature
      end
    }
  end
}