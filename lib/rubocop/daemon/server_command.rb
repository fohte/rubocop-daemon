# frozen_string_literal: true

module RuboCop
  module Daemon
    module ServerCommand
      autoload :Base, 'rubocop/daemon/server_command/base'
      autoload :Exec, 'rubocop/daemon/server_command/exec'
      autoload :Stop, 'rubocop/daemon/server_command/stop'
    end
  end
end
