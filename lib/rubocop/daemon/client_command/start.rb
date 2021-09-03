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

            Server.new(@options.fetch(:no_daemon, false)).start(
              port: @options.fetch(:port, 0),
              allow_external_access: @options.fetch(:allow_external_access, false)
            )
          end
        end

        private

        def parser
          @parser ||= CLI.new_parser do |p|
            p.banner = 'usage: rubocop-daemon start [options]'

            p.on('-p', '--port [PORT]') { |v| @options[:port] = v }
            p.on('--no-daemon', 'Starts server in foreground with debug information') { @options[:no_daemon] = true }
            p.on('--allow-external-access', 'Allows other IPs to access the daemon') do
              @options[:allow_external_access] = true
            end
          end
        end
      end
    end
  end
end
