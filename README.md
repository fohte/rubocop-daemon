# rubocop-daemon

`rubocop-daemon` makes RuboCop faster.

**This tool is beta version.**

## Installation

`rubocop-daemon` is not released on rubygems.org yet, but you can try `rubocop-daemon`:

```sh
git clone https://github.com/fohte/rubocop-daemon.git && cd rubocop-daemon
bundle install
bundle exec rake install
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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fohte/rubocop-daemon.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
