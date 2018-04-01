# frozen_string_literal: true

require 'socket'
require 'shellwords'
require 'securerandom'

module RuboCop
  module Daemon
    class Server
      def self.token
        @token ||= SecureRandom.hex(4)
      end

      def self.start(port)
        new.start(port)
      end

      def token
        self.class.token
      end

      def start(port)
        require 'rubocop'
        @server = TCPServer.open('127.0.0.1', port)

        Cache.make_server_file(port: @server.addr[1], token: token) do
          Process.daemon(true)
          read_socket(@server.accept) until @server.closed?
        end
      end

      private

      def read_socket(socket)
        SocketReader.new(socket).read!
      rescue InvalidTokenError
        socket.puts 'token is not valid.'
      rescue ServerStopRequest
        @server.close
      rescue UnknownServerCommandError => e
        socket.puts e.message
      rescue StandardError => e
        socket.puts e.full_message
      ensure
        socket.close
      end
    end
  end
end
