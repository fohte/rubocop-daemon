# frozen_string_literal: true

module RuboCop
  module Daemon
    module ServerCommand
      class Exec < Base
        def run
          # RuboCop output is colorized by default where there is a TTY.
          # We must pass the --color option to preserve this behavior.
          unless %w[--color --no-color].any? { |f| @args.include?(f) }
            @args.unshift('--color')
          end

          RuboCop::CLI.new.run(@args)
        rescue SystemExit # rubocop:disable Lint/HandleExceptions
        end
      end
    end
  end
end
