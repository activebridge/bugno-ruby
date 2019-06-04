# frozen_string_literal: true

module Bughub
  class Backtrace
    MAX_CONTEXT_LENGTH = 4

    attr_reader :backtrace
    attr_reader :files

    def initialize(backtrace)
      @backtrace = backtrace
      @files = {}
    end

    def parse_backtrace
      @backtrace.map do |line|
        match = line.match(/(.*):(\d+)(?::in `([^']+)')?/)

        return nil unless match

        filename = match[1]
        lineno = match[2].to_i
        method = match[3]&.tr('0-9', '')
        frame_data = {
          code: nil,
          lineno: lineno,
          method: method,
          context: nil,
          filename: filename
        }

        frame_data.merge(extra_frame_data(filename, lineno))
      end
    end

    def extra_frame_data(filename, lineno)
      file_lines = get_file_lines(filename)

      {
        code: code_data(file_lines, lineno),
        context: context_data(file_lines, lineno)
      }
    end

    def get_file_lines(filename)
      @files[filename] ||= read_file(filename)
    end

    def read_file(filename)
      return unless File.exist?(filename)

      File.read(filename).split("\n")
    rescue StandardError
      nil
    end

    def code_data(file_lines, lineno)
      file_lines[lineno - 1]
    end

    def context_data(file_lines, lineno)
      {
        pre: pre_data(file_lines, lineno),
        post: post_data(file_lines, lineno)
      }
    end

    def post_data(file_lines, lineno)
      from_line = lineno
      number_of_lines = [from_line + MAX_CONTEXT_LENGTH, file_lines.size].min - from_line

      file_lines[from_line, number_of_lines]
    end

    def pre_data(file_lines, lineno)
      to_line = lineno - 2
      from_line = [to_line - MAX_CONTEXT_LENGTH + 1, 0].max

      file_lines[from_line, (to_line - from_line + 1)].select { |line| line && !line.empty? }
    end
  end
end
