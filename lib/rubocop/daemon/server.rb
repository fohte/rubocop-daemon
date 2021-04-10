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

      def start(port, rubocop_version)
        require_rubocop(rubocop_version)
        start_server(port)
        Cache.write_port_and_token_files(port: @server.addr[1], token: token)
        Process.daemon(true) unless verbose
        Cache.write_pid_file do
          read_socket(@server.accept) until @server.closed?
        end
      end

      private

      def require_rubocop(version = nil)
        begin
          rubocop_path = Gem::Specification.find_by_name('rubocop', version).full_gem_path
          rubocop_lib_path = File.join(rubocop_path, 'lib')
          $LOAD_PATH.unshift(rubocop_lib_path) unless $LOAD_PATH.include?(rubocop_lib_path)
        rescue Gem::MissingSpecVersionError => e
          raise InvalidRuboCopVersionError,
            "could not find '#{e.name}' (#{e.requirement}) - "\
            "did find: [#{e.specs.map { |s| s.version.version }.join(', ')}]"
        end
        require 'rubocop'
      end

      def start_server(port)
        @server = TCPServer.open('127.0.0.1', port)
        puts "Server listen on port #{@server.addr[1]}" if verbose
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
