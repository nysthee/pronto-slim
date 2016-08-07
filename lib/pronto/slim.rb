require 'pronto'
require 'slim_lint'

module Pronto
  class Slim < Runner
    def initialize(_, _ = nil)
      super

      @runner = ::SlimLint::Runner.new
    end

    def run
      return [] unless @patches

      @patches.select { |patch| patch.additions > 0 }
              .select { |patch| slim_file?(patch.new_file_full_path) }
              .map { |patch| inspect(patch) }
              .flatten.compact
    end

    def inspect(patch)
      lints = @runner.run(files: [patch.new_file_full_path.to_s]).lints
      lints.map do |lint|
        patch.added_lines.select { |line| line.new_lineno == lint.line }
             .map { |line| new_message(lint, line) }
      end
    end

    def new_message(lint, line)
      path = line.patch.delta.new_file[:path]
      Message.new(path, line, lint.severity, lint.message, nil, self.class)
    end

    private

    def slim_file?(path)
      File.extname(path) == '.slim'
    end
  end
end
