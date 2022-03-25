# frozen_string_literal: true

module RuboCop
  module Daemon
    module ClientCommand
      class Stop < Base
        def run
          return unless server_running?

          parser.parse(@argv)
          send_request(command: 'stop')
          Daemon.wait_for_running_status!(false)
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
