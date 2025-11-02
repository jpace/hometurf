require 'hometurf/home_file'
require 'hometurf/location'
require 'fileutils'

module Hometurf
  class ProjectFiles < Location
    IGNORED = %w( .git )

    def elements
      @elements ||= dir.children
    end

    def ignored? file
      IGNORED.include? file.basename.to_s
    end
  end
end
