require 'hometurf/locations'
require 'hometurf/home_file'
require 'hometurf/files'
require 'hometurf/view/files_view'
require 'hometurf/view/files_view_brief'

module Hometurf
  class App
    def initialize locations
      @locations = locations
    end

    def add_link file
      puts "add link: #{file}"
    end

    def set_link file
      puts "add link: #{file}"
    end

    def status
      puts "status"
      statuses = Files.new @locations
      view = FilesViewBrief.new statuses
      view.render
    end
  end
end
