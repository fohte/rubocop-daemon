# frozen_string_literal: true

module RuboCop
  module Daemon
    module ClientCommand
      class Stop < Base
        def run
          parser.parse(@argv)
          check_running_server!
          send_request(command: 'stop')
        end

        private

        def parser
          @parser ||= CLI.new_parser do |p|
            p.banner = 'usage: rubocop-daemon stop'
          end
        end
      end
    end
  end
end
