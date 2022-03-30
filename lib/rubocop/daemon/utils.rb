require 'rubocop'
require 'stringio'

module RuboCop
  module Daemon
    module Utils
      def self.config
        RuboCop::ConfigStore.new.for_pwd.signature.strip
      end

      def self.versions(args)
        cli = RuboCop::CLI.new
        args = args.dup
        args.delete('--')
        Helper.redirect(stdout: StringIO.new) do
          cli.run([*args, '--verbose-version'])
        end
        RuboCop::Version.version(debug: true, env: cli.instance_variable_get(:@env)).strip
      end
    end
  end
end
