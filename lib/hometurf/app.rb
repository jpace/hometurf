require 'hometurf/locations'
require 'hometurf/home_file'
require 'hometurf/files'
require 'hometurf/files_view'

module Hometurf
  class App
    def initialize
      puts "this is app"
    end

    def add_link file
      puts "add link: #{file}"
    end

    def status
      puts "status"
      locations = Locations.new(files: Pathname("/tmp/ht-test/proj/homefiles"), home: Pathname("/tmp/ht-test/proj/home"))
      statuses = Files.new locations
      view = FilesView.new statuses
      view.render
    end
  end
end
