# frozen_string_literal: true

module RuboCop
  module Daemon
    module Helper
      def self.redirect(stdin: $stdin, stdout: $stdout, stderr: $stderr, &_block)
        old_stdin = $stdin.dup
        old_stdout = $stdout.dup
        old_stderr = $stderr.dup

        $stdin = stdin
        $stdout = stdout
        $stderr = stderr

        yield
      ensure
        $stdin = old_stdin
        $stdout = old_stdout
        $stderr = old_stderr
      end
    end
  end
end
