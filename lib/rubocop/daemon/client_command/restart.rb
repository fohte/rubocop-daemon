# frozen_string_literal: true

module RuboCop
  module Daemon
    module ClientCommand
      class Restart < Base
        def run
          parser.parse(@argv)
          check_running_server!
          send_request(command: 'stop')
          Server.new.start(@options.fetch(:port, 0))
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
