# frozen_string_literal: true

module Hometurf
  class HomeFile
    attr_reader :file
    attr_reader :link

    def initialize(file)
      @file = file
      if file.symlink?
        # what if it's a link to a link to a link ...?
        @link = file.readlink
      else
        @link = nil
      end
    end

    def to_s
      "file: #{@file}, link: #{@link}"
    end
  end
end
