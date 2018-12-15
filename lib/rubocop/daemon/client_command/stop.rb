# frozen_string_literal: true

module RuboCop
  module Daemon
    module ClientCommand
      class Stop < Base
        TIMEOUT = 10

        def run
          return unless check_running_server

          parser.parse(@argv)
          send_request(command: 'stop')

          start_time = Time.now
          while Daemon.running?
            sleep 0.1
            if Time.now - start_time > TIMEOUT
              warn "rubocop-daemon was still running after #{TIMEOUT} seconds!"
              exit 1
            end
          end
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
