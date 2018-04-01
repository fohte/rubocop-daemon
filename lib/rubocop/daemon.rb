# frozen_string_literal: true

module RuboCop
  module Daemon
    autoload :VERSION, 'rubocop/daemon/version'

    autoload :CLI, 'rubocop/daemon/cli'
    autoload :Cache, 'rubocop/daemon/cache'
    autoload :ClientCommand, 'rubocop/daemon/client_command'
    autoload :Helper, 'rubocop/daemon/helper'
    autoload :Server, 'rubocop/daemon/server'
    autoload :ServerCommand, 'rubocop/daemon/server_command'
    autoload :SocketReader, 'rubocop/daemon/socket_reader'

    def self.running?
      Cache.dir.exist?
    end
  end
end

require 'rubocop/daemon/errors'
