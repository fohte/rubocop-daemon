# frozen_string_literal: true

module RuboCop
  module Daemon
    module ClientCommand
      class Start < Base
        def run
          if Daemon.running?
            warn 'rubocop-daemon: server is already running.'
            return
          end

          Cache.acquire_lock do |locked|
            unless locked
              # Another process is already starting the daemon,
              # so wait for it to be ready.
              Daemon.wait_for_running_status!(true)
              exit 0
            end

            parser.parse(@argv)
            Server.new(@options.fetch(:no_daemon, false)).start(@options.fetch(:port, 0), @options.fetch(:rubocop_version, nil))
          end
        end

        private

        def parser
          @parser ||= CLI.new_parser do |p|
            p.banner = 'usage: rubocop-daemon start [options]'

            p.on('-p', '--port [PORT]') { |v| @options[:port] = v }
            p.on('--no-daemon', 'Starts server in foreground with debug information') { @options[:no_daemon] = true }
            p.on('--rubocop-version [VERSION]', 'The version of rubocop to use.') { |v| @options[:rubocop_version] = v }
          end
        end
      end
    end
  end
end
