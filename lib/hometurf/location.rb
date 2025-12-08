require 'pathname'
require 'hometurf/ignore_file'

module Hometurf
  class Location
    attr_reader :dir

    def initialize dir, executor
      @dir = dir
      @executor = executor
    end

    def ignored? file
      ignore_file.ignored? file
    end

    def element pn
      dir + pn.basename
    end

    def dotfile? file
      file.basename.to_s.start_with? "."
    end

    def under_directory? file
      path = file.expand_path
      until path.root?
        return true if path == dir
        path = path.parent
      end
      false
    end
  end
end
