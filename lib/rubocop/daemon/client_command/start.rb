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
            if locked
              parser.parse(@argv)
              verbose = @options.fetch(:no_daemon, false)
              if verbose
                Server.new(verbose).start(@options.fetch(:port, 0))
              else
                fork do
                  Server.new(verbose).start(@options.fetch(:port, 0))
                end
              end
            end

            Daemon.wait_for_running_status!(true)
          end
        end

        private

        def parser
          @parser ||= CLI.new_parser do |p|
            p.banner = 'usage: rubocop-daemon start [options]'

            p.on('-p', '--port [PORT]') { |v| @options[:port] = v }
            p.on('--no-daemon', 'Starts server in foreground with debug information') { @options[:no_daemon] = true }
          end
        end
      end
    end
  end
end
