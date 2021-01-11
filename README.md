# rubocop-daemon

[![Gem](https://img.shields.io/gem/v/rubocop-daemon.svg)](https://rubygems.org/gems/rubocop-daemon)

`rubocop-daemon` makes RuboCop faster.

## Installation

Install `rubocop-daemon` via rubygems.org:

```sh
gem install rubocop-daemon
```

or if you install RuboCop using bundler, put this in your `Gemfile`:

```ruby
gem 'rubocop-daemon', require: false
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

You will need to manually download and install the bash script:

> (Unfortunately [this cannot be done automatically with `rubygems`](https://github.com/rubygems/rubygems/issues/88).)

```
curl https://raw.githubusercontent.com/fohte/rubocop-daemon/master/bin/rubocop-daemon-wrapper -o /tmp/rubocop-daemon-wrapper
sudo mkdir -p /usr/local/bin/rubocop-daemon-wrapper
sudo mv /tmp/rubocop-daemon-wrapper /usr/local/bin/rubocop-daemon-wrapper/rubocop
sudo chmod +x /usr/local/bin/rubocop-daemon-wrapper/rubocop
```

Add `/usr/local/bin/rubocop-daemon-wrapper` to the beginning of your `PATH`:

```bash
# ~/.bashrc
export PATH="/usr/local/bin/rubocop-daemon-wrapper:$PATH"
```

Now the `rubocop` wrapper command will always be used by default.

`rubocop-daemon-wrapper` will automatically start the daemon server if it is not already running. So the first call will be about the same as `rubocop`, but the second call will be much faster.

### Use with Bundler

If you install `rubocop-daemon` with bundler, you should set `RUBOCOP_DAEMON_USE_BUNDLER` environment variable:

```console
$ export RUBOCOP_DAEMON_USE_BUNDLER=true
```

Now `rubocop-daemon-wrapper` will call the `rubocop-daemon` command with `bundle exec`.

### Use with VS Code

Install [vscode-rubocop](https://marketplace.visualstudio.com/items?itemName=misogi.ruby-rubocop) extension, and then add configs to your VS Code `settings.json`:

```json
"[ruby]": {
  "editor.defaultFormatter": "misogi.ruby-rubocop"
},
"ruby.rubocop.executePath": "/usr/local/bin/rubocop-daemon-wrapper/",
```

Now VS Code will use the `rubocop-daemon` script, and `formatOnSave` should be much faster (~150ms instead of 3-5 seconds).

### Use with Neovim/Vim8 and ALE

[ALE](https://github.com/w0rp/ale) setting example:

```vim
" Use `rubocop-daemon-wrapper` instead of `rubocop`
let g:ale_ruby_rubocop_executable = 'rubocop-daemon-wrapper'
```

Auto-correct on save setting example:

```vim
" optional: Set fixer(not only linter).
let g:ale_fixers = {
\   'ruby': ['rubocop'],
\}

" optional: Auto-correct on save.
let g:ale_fix_on_save = 1
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fohte/rubocop-daemon.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
