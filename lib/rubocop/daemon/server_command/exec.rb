# frozen_string_literal: true

module RuboCop
  module Daemon
    module ServerCommand
      class Exec < Base
        def run
          options, files = RuboCop::Options.new.parse(@args)
          config_store = RuboCop::ConfigStore.new

          RuboCop::Runner.new(options, config_store).run(files)
        rescue SystemExit # rubocop:disable Lint/HandleExceptions
        end
      end
    end
  end
end
