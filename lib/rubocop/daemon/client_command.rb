# frozen_string_literal: true

module RuboCop
  module Daemon
    module ClientCommand
      autoload :Base, 'rubocop/daemon/client_command/base'
      autoload :Exec, 'rubocop/daemon/client_command/exec'
      autoload :Restart, 'rubocop/daemon/client_command/restart'
      autoload :Start, 'rubocop/daemon/client_command/start'
      autoload :Status, 'rubocop/daemon/client_command/status'
      autoload :Stop, 'rubocop/daemon/client_command/stop'
    end
  end
end
