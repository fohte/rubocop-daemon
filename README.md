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

- `start`: start the server
- `stop`: stop the server
- `status`: print out whether the server is currently running
- `restart`: restart the server
- `exec [file1, file2, ...] [-- [rubocop-options]]`: invoke `rubocop` with the given `rubocop-options`

## More speed

`rubocop-daemon-wrapper` is a bash script that talks to the `rubocop-daemon` server via `netcat`. This provides much lower latency than the `rubocop-daemon` Ruby script.

Unfortunately `rubygems` will wrap any executables with a Ruby script, and [there is no way to disable this behavior](https://github.com/rubygems/rubygems/issues/88).
You must manually download and install the bash script:

```
curl https://raw.githubusercontent.com/fohte/rubocop-daemon/master/bin/rubocop-daemon-wrapper -o /tmp/rubocop-daemon-wrapper
sudo mv /tmp/rubocop-daemon-wrapper /usr/local/bin/rubocop-daemon-wrapper
sudo chmod +x /usr/local/bin/rubocop-daemon-wrapper
```

You can then replace any calls to `rubocop` with `rubocop-daemon-wrapper`.

```
rubocop-daemon-wrapper foo.rb bar.rb
```

`rubocop-daemon-wrapper` will automatically start the daemon server if it is not already running.

To use `rubocop-daemon-wrapper` with the [VS Code RuboCop extension](https://github.com/misogi/vscode-ruby-rubocop), add a `rubocop` symlink in `/usr/local/bin`:

```bash
sudo ln -fs /usr/local/bin/rubocop-daemon-wrapper /usr/local/bin/rubocop
```

Unfortunately, the [vscode-ruby extension doesn't really allow you to customize the rubocop path or binary](https://github.com/rubyide/vscode-ruby/issues/413). (You can change the linter, but not the formatter.)

So in the meantime, you might want to just override the rubocop binary with a symlink:

```bash
$ which rubocop
# => /Users/username/.rvm/gems/ruby-2.5.3/bin/rubocop

$ ln -fs /usr/local/bin/rubocop-daemon-wrapper /Users/username/.rvm/gems/ruby-2.5.3/bin/rubocop
```

Now VS Code will use the `rubocop-daemon-wrapper` script, and `formatOnSave` will be much faster (< 200ms instead of 3-5 seconds).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fohte/rubocop-daemon.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
