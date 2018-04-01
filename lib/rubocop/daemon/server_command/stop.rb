# frozen_string_literal: true

module RuboCop
  module Daemon
    module ServerCommand
      class Stop < Base
        def run
          raise ServerStopRequest
        end
      end
    end
  end
end
