require "http/web_socket"

module WebSocketPinger
  VERSION = "1.0.0"

  # Starts sending PING messages to given *socket*
  # every *ping_interval* (defaults to 10 seconds)
  # with *ping_message* payload (empty by default).
  #
  # If client does not respond in *ping_timeout*
  # (defaults to 20 seconds), closes connection
  # with *close_code* (defaults to 1001 GOING AWAY)
  # and *close_message* (defaults to "closed by
  # ping-pong system").
  #
  # ```
  # my_handler = HTTP::WebSocketHandler.new do |socket, context|
  #   WebSocketPinger.start(socket)
  #   # ...rest of handler code
  # end
  # ```
  def self.start(socket,
                 ping_interval = 10.seconds,
                 ping_timeout = 20.seconds,
                 ping_message : String? = nil,
                 close_code : Int32 | HTTP::WebSocket::CloseCode = :going_away,
                 close_message = "closed by ping-pong system")
    pong_channel = Channel(Bool).new

    socket.on_pong do
      next if socket.closed?

      select
      when pong_channel.send true
      else
      end
    end

    spawn name: "WebSocketPinger for #{socket}" do
      loop do
        sleep ping_interval

        break if socket.closed? # If closed while sleeping

        socket.ping(ping_message)

        select
        when pong_channel.receive?
          # Nothing to do, all is OK
        when timeout ping_timeout
          socket.close close_code, close_message unless socket.closed?
        end

        break if socket.closed? # If closed while receiving
      end

      pong_channel.close
    end
  end
end
