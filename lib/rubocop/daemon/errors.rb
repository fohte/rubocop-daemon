# frozen_string_literal: true

module RuboCop
  module Daemon
    class InvalidTokenError < StandardError; end
    class ServerIsNotRunningError < StandardError; end
    class ServerStopRequest < StandardError; end
    class UnknownClientCommandError < StandardError; end
    class UnknownServerCommandError < StandardError; end
  end
end
