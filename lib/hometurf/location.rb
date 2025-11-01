require 'pathname'

module Hometurf
  class Location
    attr_reader :dir

    def initialize dir
      @dir = dir
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
        if path == dir
          return true
        else
          path = path.parent
        end
      end
      false
    end
  end
end
