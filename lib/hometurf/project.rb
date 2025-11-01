require 'hometurf/home_file'
require 'hometurf/location'
require 'fileutils'

module Hometurf
  class ProjectFiles < Location
    def elements
      @elements ||= dir.children
    end
  end
end
