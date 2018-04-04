# rubocop-daemon

[![Gem](https://img.shields.io/gem/v/rubocop-daemon.svg)](https://rubygems.org/gems/rubocop-daemon)

`rubocop-daemon` makes RuboCop faster.

## Installation

Install `rubocop-daemon` via rubygems.org:

```sh
gem install rubocop-daemon
```

## Usage

To start the server, just run:

```sh
rubocop-daemon start
```

Then you can execute RuboCop fast:

```sh
rubocop-daemon exec
```

And you can pass files:

```sh
rubocop-daemon exec foo.rb bar.rb
```

If you want to pass arguments to RuboCop, you should separate arguments by `--`:

```sh
rubocop-daemon exec -- --auto-correct
```

## Commands

You can control the server like this:

```
rubocop-daemon <command>
```

Available commands:

* `start`: start the server
* `stop`: stop the server
* `status`: print out whether the server is currently running
* `restart`: restart the server
* `exec [file1, file2, ...] [-- [rubocop-options]]`: invoke `rubocop` with the given `rubocop-options`

## More speed

If you're really into performance and want the lowest possible latency, talk to the `rubocop-daemon` server with netcat:

```sh
echo "$(cat ~/.cache/rubocop-daemon/token) $PWD exec [rubocop-options]" | nc localhost $(cat ~/.cache/rubocop-daemon/port)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fohte/rubocop-daemon.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
