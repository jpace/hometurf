# frozen_string_literal: true

module Hometurf
  class HomeFile
    attr_reader :file
    attr_reader :link

    def initialize file
      @file = file
      if file.symlink?
        @link = file.realpath
      else
        @link = nil
      end
    end

    def to_s
      "file: #{@file}, link: #{@link}"
    end
  end
end
