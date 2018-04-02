# frozen_string_literal: true

module RuboCop
  module Daemon
    module ServerCommand
      class Exec < Base
        def run
          RuboCop::CLI.new.run(@args)
        rescue SystemExit # rubocop:disable Lint/HandleExceptions
        end
      end
    end
  end
end
