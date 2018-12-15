# frozen_string_literal: true

module RuboCop
  module Daemon
    module ClientCommand
      class Restart < Base
        def run
          parser.parse(@argv)
          send_request(command: 'stop') if check_running_server
          Server.new(@options.fetch(:no_daemon, false)).start(@options.fetch(:port, 0))
        end

        private

        def parser
          @parser ||= CLI.new_parser do |p|
            p.banner = 'usage: rubocop-daemon restart'

            p.on('-p', '--port [PORT]') { |v| @options[:port] = v }
          end
        end
      end
    end
  end
end
