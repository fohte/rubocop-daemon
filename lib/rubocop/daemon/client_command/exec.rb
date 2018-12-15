# frozen_string_literal: true

module RuboCop
  module Daemon
    module ClientCommand
      class Exec < Base
        def run
          args = parser.parse(@argv)
          ensure_server!
          send_request(
            command: 'exec',
            args: args,
            body: $stdin.tty? ? '' : $stdin.read,
          )
        end

        private

        def parser
          @parser ||= CLI.new_parser do |p|
            p.banner = 'usage: rubocop-daemon exec [options] [files...] [-- [rubocop-options]]'
          end
        end
      end
    end
  end
end
