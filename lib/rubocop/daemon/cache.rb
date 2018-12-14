# frozen_string_literal: true

require 'pathname'

module RuboCop
  module Daemon
    class Cache
      def self.dir
        Pathname.new(File.join(File.expand_path('~/.cache/rubocop-daemon'), Dir.pwd[1..-1].tr('/', '+'))).tap do |d|
          d.mkpath unless d.exist?
        end
      end

      def self.port_path
        dir.join('port')
      end

      def self.token_path
        dir.join('token')
      end

      def self.pid_path
        dir.join('pid')
      end

      def self.pid_running?
        Process.kill 0, pid_path.read.to_i
      rescue Errno::ESRCH
        false
      end

      def self.make_server_file(port:, token:)
        port_path.write(port)
        token_path.write(token)
        pid_path.write(Process.pid)
        yield
      ensure
        dir.rmtree
      end
    end
  end
end
