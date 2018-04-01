# frozen_string_literal: true

require 'shellwords'
require 'socket'

module RuboCop
  module Daemon
    module ClientCommand
      class Base
        def initialize(argv)
          @argv = argv.dup
          @options = {}
        end

        def run; end

        private

        def send_request(command:, args: [], body: '')
          TCPSocket.open('127.0.0.1', Cache.port_path.read) do |socket|
            socket.puts [Cache.token_path.read, Dir.pwd, command, *args].shelljoin
            socket.write body
            socket.close_write
            STDOUT.write socket.read(4096) until socket.eof?
          end
        end

        def check_running_server!
          raise ServerIsNotRunningError unless Daemon.running?
        end
      end
    end
  end
end
