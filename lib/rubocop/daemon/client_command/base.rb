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
          current_versions = Utils.versions(@argv)
          server_versions = Cache.version_path.file? ? Cache.version_path.read : nil
          versions_match = (server_versions == current_versions)
          warn 'rubocop-daemon: server is running an obsolete version' unless versions_match

          current_config = Utils.config
          server_config = Cache.config_path.file? ? Cache.config_path.read : nil
          config_match = (server_config == current_config)
          warn 'rubocop-daemon: server is running an obsolete config' unless config_match

          versions_match && config_match
        end

        def ensure_server!
          ClientCommand::Start.new([]).run unless server_running?
          ClientCommand::Restart.new([]).run unless server_up_to_date?
        end
      end
    end
  end
end
