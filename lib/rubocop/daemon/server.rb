# frozen_string_literal: true

require 'socket'
require 'shellwords'
require 'securerandom'

module RuboCop
  module Daemon
    class Server
      attr_reader :verbose

      def self.token
        @token ||= SecureRandom.hex(4)
      end

      def initialize(verbose)
        @verbose = verbose
      end

      def token
        self.class.token
      end

      def start(host, port)
        require 'rubocop'
        start_server(host, port)
        Cache.write_port_and_token_files(port: @server.addr[1], token: token)
        Process.daemon(true) unless verbose
        Cache.write_pid_file do
          read_socket(@server.accept) until @server.closed?
        end
      end

      private

      def start_server(host, port)
        @server = TCPServer.open(host, port)
        puts "Server listen on #{@server.addr[3]}:#{@server.addr[1]}" if verbose
      end

      def read_socket(socket)
        SocketReader.new(socket, verbose).read!
      rescue InvalidTokenError
        socket.puts 'token is not valid.'
      rescue ServerStopRequest
        @server.close
      rescue UnknownServerCommandError => e
        socket.puts e.message
      rescue Errno::EPIPE => e
        p e if verbose
      rescue StandardError => e
        socket.puts e.full_message
      ensure
        socket.close
      end
    end
  end
end
