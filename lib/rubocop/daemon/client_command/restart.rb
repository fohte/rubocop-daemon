# frozen_string_literal: true

module RuboCop
  module Daemon
    module ClientCommand
      class Restart < Base
        def run
          parser.parse(@argv)

          ClientCommand::Stop.new([]).run
          ClientCommand::Start.new(@argv).run
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
