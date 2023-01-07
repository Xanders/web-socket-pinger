# WebSocket Pinger

[![GitHub release](https://img.shields.io/github/release/Xanders/web-socket-pinger.svg)](https://github.com/Xanders/web-socket-pinger/releases)

The WebSocket spec defines a PING-PONG system that allows
the side sending the PING to ensure that the other side
is still alive.

Crystal Language has proper PONG-response system built-in.
But there is no automatic system for sending PING messages
at intervals.

I'm sure every project that uses WebSocket doesn't want to deal
with dead connections: not closed properly or opened by villians.

So this simple library allows you to enable PING sending
for every WebSocket connection and closes it in case of no
PONG response within a given timeout period.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     web-socket-pinger:
       github: Xanders/web-socket-pinger
   ```

2. Run `shards install`

## Usage

Just add `WebSocketPinger.start(socket)`
to the head of your handler:

```crystal
require "http/web_socket"

require "web-socket-pinger"

my_handler = HTTP::WebSocketHandler.new do |socket, context|
  WebSocketPinger.start(socket)
  # ...rest of handler code
end

server = HTTP::Server.new [my_handler]
server.bind_tcp "0.0.0.0", 8080
server.listen
```

## Development

I'm using [Docker](https://www.docker.com) for library development.
If you have Docker available, you can use `make` command
to see the help, powered by [make-help](https://github.com/Xanders/make-help) project.
There are commands for testing, formatting and documentation.

Sadly, I have no idea, how to test this properly.
If you have any ideas, please open the Issue or Pull Request.

## Contributing

1. Fork it (<https://github.com/Xanders/web-socket-pinger/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
