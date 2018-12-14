# frozen_string_literal: true

module RuboCop
  module Daemon
    module ClientCommand
      class Start < Base
        def run
          parser.parse(@argv)
          Server.new(@options.fetch(:no_daemon, false)).start(@options.fetch(:port, 0))
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
