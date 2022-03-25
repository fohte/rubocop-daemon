# frozen_string_literal: true

require 'shellwords'
require 'socket'
require 'stringio'

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

        def send_request(command:, args: [], body: '', output: STDOUT)
          TCPSocket.open('127.0.0.1', Cache.port_path.read) do |socket|
            socket.puts [Cache.token_path.read, Dir.pwd, command, *args].shelljoin
            socket.write body
            socket.close_write
            output.write socket.read(4096) until socket.eof?
          end
        end

        def server_running?
          Daemon.running?.tap do |running|
            warn 'rubocop-daemon: server is not running.' unless running
          end
        end

        def server_up_to_date?
          current_versions = StringIO.new
          send_request(
            command: 'exec',
            args: ['--verbose-version', *@argv],
            output: current_versions,
          )
          current_versions.rewind
          current_versions = current_versions.read.strip
          server_versions = Cache.version_path.file? ? Cache.version_path.read.strip : nil
          (server_versions == current_versions).tap do |up_to_date|
            warn 'rubocop-daemon: server is running an obsolete version' unless up_to_date
          end
        end

        def ensure_server!
          ClientCommand::Start.new([]).run unless server_running?
          ClientCommand::Restart.new([]).run unless server_up_to_date?
        end
      end
    end
  end
end
